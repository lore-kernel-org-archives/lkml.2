Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3AGIAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 03:00:39 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:8239 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab3AGIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 03:00:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,422,1355094000"; 
   d="scan'208";a="167580613"
Date: Mon, 7 Jan 2013 09:00:30 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Anton Vorontsov <anton@enomsg.org>
cc: Dan Carpenter <dan.carpenter@oracle.com>, kernel-janitors@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/power/88pm860x_battery.c: eliminate possible
 references to released resources
In-Reply-To: <20130107065321.GA31407@lizard.gateway.2wire.net>
Message-ID: <alpine.DEB.2.02.1301070859380.1908@hadrien>
References: <1354986995-2324-1-git-send-email-Julia.Lawall@lip6.fr> <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net> <alpine.DEB.2.02.1301060941400.2070@localhost6.localdomain6> <20130106211649.GA26928@lizard.sbx05280.losalca.wayport.net>
 <20130107064223.GR7247@mwanda> <20130107065321.GA31407@lizard.gateway.2wire.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2013, Anton Vorontsov wrote:

> On Mon, Jan 07, 2013 at 09:42:23AM +0300, Dan Carpenter wrote:
> > On Sun, Jan 06, 2013 at 01:16:50PM -0800, Anton Vorontsov wrote:
> > > The patch is whitespace-damaged (for some reason there are two spaces in
> > > the beginning of each non-change line). I repeated changes manually, but
> > > you might want to fix your mail/patch setup anyway. :)
> > >
> >
> > It may be something on your end, the patch applies fine for me.
>
> I just looked into Julia's email headers, and it says:
>
>   Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
>
> flowed? for the patch? :) That's not right.
>
> Documentation/email-clients.txt says:
>
>   Don't send patches with "format=flowed".  This can cause unexpected
>   and unwanted line breaks.

That is what I fixed.  I had used that mailer before for sending patches,
and even fixed the problem before, so I have no idea why it changed...
But it is fixed now.

thanks,
julia
