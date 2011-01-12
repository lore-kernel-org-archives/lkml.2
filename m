Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1ALFSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:18:50 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:44681 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1ALFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:18:47 -0500
Date: Wed, 12 Jan 2011 00:18:39 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-acpi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        akpm <akpm@linux-foundation.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>
Subject: Re: [PATCH -next] thermal: depends on NET
In-reply-to: <20110110090059.6f4d739d.randy.dunlap@oracle.com>
Message-id: <alpine.LFD.2.02.1101120008590.19140@x980>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
 <20101213112033.d0060e6c.randy.dunlap@oracle.com>
 <20110110090059.6f4d739d.randy.dunlap@oracle.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- linux-next-20101213.orig/drivers/thermal/Kconfig
> > +++ linux-next-20101213/drivers/thermal/Kconfig
> > @@ -4,6 +4,7 @@
> >  
> >  menuconfig THERMAL
> >  	tristate "Generic Thermal sysfs driver"
> > +	depends on NET

I've added this line to the offending patch.

While I agree that randconfig build testing
is theoretically useful, in recent memory
its results do not seem particularly relevant
to useful configs.

Perhaps it would be a good idea to spend some time
making non-useful configs impossible, and thus focus
the testing where it will be of more benefit?

thanks,
Len Brown, Intel Open Source Technology Center
