Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0LFRcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:32:33 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:46195 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751254Ab0LFRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:32:31 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 12:32:31 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fOF17n7Oy0NR4iIt1wKP2TYliC0WL0TLhiT6z+gIX3j3kj4x1Hq/EdTLkxf0OjG9pmQ6P+T2jJbGAgvgOWwQ4xDclPwGCNksZpny3Bo/CILi/PO4pdp1KJgldCfTbJHX;
Date: Mon, 6 Dec 2010 09:25:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Nicolas Kaiser <nikai@nikai.net>,
        Tiago Vignatti <tiago.vignatti@nokia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: vgaarbiter: fix typos
Message-ID: <20101206092544.68cb5036@jbarnes-desktop>
In-Reply-To: <20101201164141.abc97309.rdunlap@xenotime.net>
References: <20101201023457.739373c7@absol.kitzblitz>
	<20101201164141.abc97309.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010 16:41:41 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Wed, 1 Dec 2010 02:34:57 +0100 Nicolas Kaiser wrote:
> 
> > Fixed typos.
> > 
> > Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> > ---
> >  Documentation/vgaarbiter.txt |   15 +++++++--------
> >  1 files changed, 7 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/vgaarbiter.txt b/Documentation/vgaarbiter.txt
> > index 43a9b06..8145f8f 100644
> > --- a/Documentation/vgaarbiter.txt
> > +++ b/Documentation/vgaarbiter.txt
> > @@ -14,11 +14,10 @@ the legacy VGA arbitration task (besides other bus management tasks) when more
> >  than one legacy device co-exists on the same machine. But the problem happens
> >  when these devices are trying to be accessed by different userspace clients
> >  (e.g. two server in parallel). Their address assignments conflict. Moreover,
> > -ideally, being an userspace application, it is not the role of the the X
> > -server to control bus resources. Therefore an arbitration scheme outside of
> > -the X server is needed to control the sharing of these resources. This
> > -document introduces the operation of the VGA arbiter implemented for Linux
> > -kernel.
> > +ideally, being a userspace application, it is not the role of the X server to
> > +control bus resources. Therefore an arbitration scheme outside of the X server
> > +is needed to control the sharing of these resources. This document introduces
> > +the operation of the VGA arbiter implemented for the Linux kernel.
> >  
> >  ----------------------------------------------------------------------------
> >  
> > @@ -39,7 +38,7 @@ I.1 vgaarb
> >  The vgaarb is a module of the Linux Kernel. When it is initially loaded, it
> >  scans all PCI devices and adds the VGA ones inside the arbitration. The
> >  arbiter then enables/disables the decoding on different devices of the VGA
> > -legacy instructions. Device which do not want/need to use the arbiter may
> > +legacy instructions. Devices which do not want/need to use the arbiter may
> >  explicitly tell it by calling vga_set_legacy_decoding().
> >  
> >  The kernel exports a char device interface (/dev/vga_arbiter) to the clients,
> > @@ -95,7 +94,7 @@ In the case of devices hot-{un,}plugged, there is a hook - pci_notify() - to
> >  notify them being added/removed in the system and automatically added/removed
> >  in the arbiter.
> >  
> > -There's also a in-kernel API of the arbiter in the case of DRM, vgacon and
> > +There's also an in-kernel API of the arbiter in the case of DRM, vgacon and
> >  others which may use the arbiter.
> >  
> 
> How about:
> 
> There is also an in-kernel API of the arbiter in case DRM, vgacon, or other
> drivers want to use it.
> 
> >  
> > @@ -117,7 +116,7 @@ Besides it, in pci_system were added:
> >      struct pci_device *vga_default_dev;
> >  
> >  
> > -The vga_count is usually need to keep informed how many cards are being
> > +The vga_count is usually needed to keep informed how many cards are being
> >  arbitrated, so for instance if there's only one then it can totally escape the
> >  scheme.
> 
> Awkward.  How about:
> 
> The vga_count is used to track how many cards are being arbitrated, so for
> instance, if there is only one card, then it can completely escape arbitration.

Randy, I assume you'll pick this up once you receive a version you're
ok with?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
