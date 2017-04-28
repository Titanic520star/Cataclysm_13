/datum/preferences/proc/ShowContentPacks(mob/user)
	var/packs_data
	for(var/P in SScontent.all_content_packs)
		var/classes
		if(P in parent.content_packs)
			classes += "have"
		if(P == selected_pack)
			classes += " linkOn"
		var/datum/content_pack/pack = SScontent.get_pack(P)
		packs_data += "<a class='[classes]' href='?_src_=prefs;preference=content_packs;pack=[pack.id]' data-tooltip=\"[quoter(pack.desc)]\">[pack.name]</a><br>"
	var/list/spack_data = list()
	if(!selected_pack)
		selected_pack = "starter"

	var/datum/content_pack/pack = SScontent.get_pack(selected_pack)
	spack_data["name"] = "[pack.name]"
	spack_data["desc"] = "[pack.desc]"
	spack_data["price"] = "[pack.price]"
	spack_data["id"] = "[pack.id]"
	if(pack.items.len)
		var/temp
		for(var/item in pack.items)
			temp = get_var_from_type(item, "name")
			spack_data["items"] += "<li data-tooltip=\"[ItemTooltip(temp, get_var_from_type(item, "desc"))]\">[get_var_from_type(item, "name")]</li>"
	if(pack.roles.len)
		for(var/role in pack.roles)
			spack_data["roles"] += "<li>[get_var_from_type(role, "title")]</li>"
	if(pack.roles.len)
		for(var/pet in pack.pets)
			spack_data["pets"] += "<li>[get_var_from_type(pet, "name")]</li>"

	var/html = {"
		<div class="left_table">
		  <center>Packs</center>
			  [packs_data]
		</div>
		  <div class="right_table">
		  	<center>[spack_data["name"]]</center>
		  	<span style="float: right; font-style: normal; font-weight: lighter; font-size: xx-small;">balance: [parent.donate_money] </span><br>
		  	description:
		  	<p style="margin-left: 25px; font-size: x-small;">[spack_data["desc"]]</p>
		  	Price: [(pack.id in parent.content_packs) ? "purchased" : pack.price]<br>
           	<a [(selected_pack in parent.content_packs) ? "class='linkOff'" : ""] href='?_src_=prefs;preference=content_packs;buy=[pack.id]'>Buy</a>
            <div style="display: block; width: 98%; border: 1px solid #0bcc62; padding-top: 5px; padding-right: 5px; padding-bottom: 5px; padding-left: 5px">
              <div style="width: 30%; display: inline-block; float: left;">
                Items:
                <ul style="margin-left: 25px;">
                  [spack_data["items"]]
                  </ul>
              </div>
              <div style="width: 30%; display: inline-block; float: left;">
                Roles:
                <ul style="margin-left: 25px;">
                  [spack_data["roles"]]
                  </ul>
                </div>
              <div style="width: 30%; display: inline-block; float: left;">
                Pets:
                <ul style="margin-left: 25px;">
                  [spack_data["pets"]]
                  </ul>
                </div>
                <div style="width: 100%;clear: both; "></div>
            </div>
		  </div>"}
	var/datum/browser/popup = new(user, "packs", "<div align='center'>Content Packs</div>", 640, 350)
	popup.set_content(html)
	popup.open(0)