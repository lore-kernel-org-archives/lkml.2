Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2KYNoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:44:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61516 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2KYNom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:44:42 -0500
Date: Sun, 25 Nov 2012 14:44:40 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: memory-cgroup bug
Message-ID: <20121125134440.GD10623@dhcp22.suse.cz>
References: <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121123155904.490039C5@pobox.sk>
 <20121125101707.GA10623@dhcp22.suse.cz>
 <20121125133953.AD1B2F0A@pobox.sk>
 <20121125130208.GC10623@dhcp22.suse.cz>
 <20121125142709.19F4E8C2@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125142709.19F4E8C2@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 25-11-12 14:27:09, azurIt wrote:
> >> Thank you very much, i will install it ASAP (probably this night).
> >
> >Please don't. If my analysis is correct which I am almost 100% sure it
> >is then it would cause excessive logging. I am sorry I cannot come up
> >with something else in the mean time.
> 
> 
> Ok then. I will, meanwhile, try to contact Andrea Righi (author of
> cgroup-task etc.) and ask him to send here his opinion about relation
> between freezes and his patches.

As I described in other email. This seems to be a deadlock in memcg oom
so I do not think that other patches influence this.

-- 
Michal Hocko
SUSE Labs
