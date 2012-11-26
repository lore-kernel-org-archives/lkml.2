Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2KZH5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 02:57:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab2KZH5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 02:57:09 -0500
Date: Mon, 26 Nov 2012 08:57:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: memory-cgroup bug
Message-ID: <20121126075656.GA17860@dhcp22.suse.cz>
References: <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121125011047.7477BB5E@pobox.sk>
 <20121125120524.GB10623@dhcp22.suse.cz>
 <20121125135542.GE10623@dhcp22.suse.cz>
 <20121126013855.AF118F5E@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126013855.AF118F5E@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-11-12 01:38:55, azurIt wrote:
> >This is hackish but it should help you in this case. Kamezawa, what do
> >you think about that? Should we generalize this and prepare something
> >like mem_cgroup_cache_charge_locked which would add __GFP_NORETRY
> >automatically and use the function whenever we are in a locked context?
> >To be honest I do not like this very much but nothing more sensible
> >(without touching non-memcg paths) comes to my mind.
> 
> 
> I installed kernel with this patch, will report back if problem occurs
> again OR in few weeks if everything will be ok. Thank you!

Thanks!

> Btw, will this patch be backported to 3.2?

Once we agree on a proper solution it will be backported to the stable
trees.

-- 
Michal Hocko
SUSE Labs
