Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab1CYBeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:34:17 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:40546 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1CYBeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:34:16 -0400
Date: Thu, 24 Mar 2011 21:34:02 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
In-reply-to: <20110325010705.GB4535@khazad-dum.debian.net>
Message-id: <alpine.LFD.2.02.1103242124470.32565@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>
 <alpine.LFD.2.02.1103240336590.4529@x980>
 <20110324102116.GA17446@khazad-dum.debian.net>
 <alpine.LFD.2.02.1103241903030.16085@x980>
 <20110325010705.GB4535@khazad-dum.debian.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > People with a ThinkPad T23, T30 will really not appreciate this, and it
> > > should not be too difficult to recruit some as testers.
> > 
> > I have both, and they both support ACPI.
> 
> I wonder why I had some users of those two boxes advocating APM, maybe
> it used to work better or something.  Or I got the T21 and A30 confused
> with the T23.

In 2003, APM worked better than ACPI on the T21 and the T23.
In 2005 or so, I think ACPI was working fine on them.

> Well, I don't think we need to support the thre-digit series ThinkPads,
> the number of those still working is probably on the four digits
> world-wide.  And I haven't heard from anyone with a T21 or A31 in a
> while, so they might be down to five digits already.
> 
> If the T23 can actually work well in ACPI mode, I retract my objection.

Thanks, ACPI works well on the T23.
Indeed, it works well back to the T20:-)

> > Re: lasting for years.
> > Actually, I used to have several of both, but they're dying off,
> > and they are excruciatingly slow...
> 
> Depends on what you use them for, I suppose.

My experience with old-laptops is:

1. hdd dies
2. CMOS battery dies
3. main battery dies

But from a practical view of runing a new distro on an old laptop,
the distros seem to drop the video support for the old controllers,
leaving you in VGA mode.  That is the case with the T23, which
has an S3 SuperSavage video controller.

cheers,
Len Brown, Intel Open Source Technolgy Center


