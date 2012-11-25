Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2KYNCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 08:02:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49736 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2KYNCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 08:02:11 -0500
Date: Sun, 25 Nov 2012 14:02:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: memory-cgroup bug
Message-ID: <20121125130208.GC10623@dhcp22.suse.cz>
References: <20121122152441.GA9609@dhcp22.suse.cz>
 <20121122190526.390C7A28@pobox.sk>
 <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121123155904.490039C5@pobox.sk>
 <20121125101707.GA10623@dhcp22.suse.cz>
 <20121125133953.AD1B2F0A@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125133953.AD1B2F0A@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 25-11-12 13:39:53, azurIt wrote:
> >Inlined at the end of the email. Please note I have compile tested
> >it. It might produce a lot of output.
> 
> 
> Thank you very much, i will install it ASAP (probably this night).

Please don't. If my analysis is correct which I am almost 100% sure it
is then it would cause excessive logging. I am sorry I cannot come up
with something else in the mean time.
-- 
Michal Hocko
SUSE Labs
