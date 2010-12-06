Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0LFReA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:34:00 -0500
Received: from xenotime.net ([72.52.115.56]:37191 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751695Ab0LFRd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:33:59 -0500
Date: Mon, 6 Dec 2010 09:33:53 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Nicolas Kaiser <nikai@nikai.net>,
        Tiago Vignatti <tiago.vignatti@nokia.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: vgaarbiter: fix typos
Message-Id: <20101206093353.18a5a411.rdunlap@xenotime.net>
In-Reply-To: <20101206092544.68cb5036@jbarnes-desktop>
References: <20101201023457.739373c7@absol.kitzblitz>
	<20101201164141.abc97309.rdunlap@xenotime.net>
	<20101206092544.68cb5036@jbarnes-desktop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010 09:25:44 -0800 Jesse Barnes wrote:

> On Wed, 1 Dec 2010 16:41:41 -0800
> Randy Dunlap <rdunlap@xenotime.net> wrote:
> 
> > On Wed, 1 Dec 2010 02:34:57 +0100 Nicolas Kaiser wrote:
> > 
> > > Fixed typos.
> > > 
> > > Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> > > ---
> > >  Documentation/vgaarbiter.txt |   15 +++++++--------
> > >  1 files changed, 7 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/Documentation/vgaarbiter.txt b/Documentation/vgaarbiter.txt
> > > index 43a9b06..8145f8f 100644
> > > --- a/Documentation/vgaarbiter.txt
> > > +++ b/Documentation/vgaarbiter.txt
> > > @@ -14,11 +14,10 @@ the legacy VGA arbitration task (besides other bus management tasks) when more
> > >  than one legacy device co-exists on the same machine. But the problem happens
> > >  when these devices are trying to be accessed by different userspace clients
> > >  (e.g. two server in parallel). Their address assignments conflict. Moreover,
> > > -ideally, being an userspace application, it is not the role of the the X
> > > -server to control bus resources. Therefore an arbitration scheme outside of
> > > -the X server is needed to control the sharing of these resources. This
> > > -document introduces the operation of the VGA arbiter implemented for Linux
> > > -kernel.
> > > +ideally, being a userspace application, it is not the role of the X server to
> > > +control bus resources. Therefore an arbitration scheme outside of the X server
> > > +is needed to control the sharing of these resources. This document introduces
> > > +the operation of the VGA arbiter implemented for the Linux kernel.
> > >  
> > >  ----------------------------------------------------------------------------
> > >  
> > > @@ -39,7 +38,7 @@ I.1 vgaarb
> > >  The vgaarb is a module of the Linux Kernel. When it is initially loaded, it
> > >  scans all PCI devices and adds the VGA ones inside the arbitration. The
> > >  arbiter then enables/disables the decoding on different devices of the VGA
> > > -legacy instructions. Device which do not want/need to use the arbiter may
> > > +legacy instructions. Devices which do not want/need to use the arbiter may
> > >  explicitly tell it by calling vga_set_legacy_decoding().
> > >  
> > >  The kernel exports a char device interface (/dev/vga_arbiter) to the clients,
> > > @@ -95,7 +94,7 @@ In the case of devices hot-{un,}plugged, there is a hook - pci_notify() - to
> > >  notify them being added/removed in the system and automatically added/removed
> > >  in the arbiter.
> > >  
> > > -There's also a in-kernel API of the arbiter in the case of DRM, vgacon and
> > > +There's also an in-kernel API of the arbiter in the case of DRM, vgacon and
> > >  others which may use the arbiter.
> > >  
> > 
> > How about:
> > 
> > There is also an in-kernel API of the arbiter in case DRM, vgacon, or other
> > drivers want to use it.
> > 
> > >  
> > > @@ -117,7 +116,7 @@ Besides it, in pci_system were added:
> > >      struct pci_device *vga_default_dev;
> > >  
> > >  
> > > -The vga_count is usually need to keep informed how many cards are being
> > > +The vga_count is usually needed to keep informed how many cards are being
> > >  arbitrated, so for instance if there's only one then it can totally escape the
> > >  scheme.
> > 
> > Awkward.  How about:
> > 
> > The vga_count is used to track how many cards are being arbitrated, so for
> > instance, if there is only one card, then it can completely escape arbitration.
> 
> Randy, I assume you'll pick this up once you receive a version you're
> ok with?

I wasn't sure who would, but I can do that.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
