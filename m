Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab1AFPIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:08:04 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:37201 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1AFPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:08:00 -0500
From: Anand Gadiyar <gadiyar@ti.com>
References: <20101223171859.f6842045.sfr@canb.auug.org.au><4D139517.3010608@ti.com>
 <AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcutsrCrJiiYnH/3Syyh3/ldv42g9wAAB5Eg
In-Reply-To: <AANLkTi=pTNg2iWN+=uEv=CyZHHCoddF51pmmCMjPeMUF@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Thu, 6 Jan 2011 20:37:59 +0530
Message-ID: <4ce0f816f951f24ca3de9c84d9f70842@mail.gmail.com>
Subject: RE: linux-next: manual merge of the usb tree with the omap tree
To: Ming Lei <tom.leiming@gmail.com>, Benoit Cousson <b-cousson@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei wrote:

> Hi,
>
> 2010/12/24 Cousson, Benoit <b-cousson@ti.com>:
> > + Paul "the omap clock guru".
> >
> > At first glance, that seems almost good.
> > Except for a couple of nodes that seems to lose their 3630 support.
> >
> > I'm just wondering why the original usb clock node is
> > kept after the introduction of the "ehci-omap.0" clock
> > node. But this is anyway harmless.
> >
> > What commits are generating this conflict?
> >
> > On 12/23/2010 7:18 AM, Stephen Rothwell wrote:
> >> Hi Greg,
> >>
> >> Today's linux-next merge of the usb tree got a conflict in
> >> arch/arm/mach-omap2/clock3xxx_data.c and
> >> arch/arm/mach-omap2/clock44xx_data.c between various commits from the
omap
> >> tree and various commits from the usb tree.
> >>
> >> I did a quick fix (which may be completely wrong - see below).
> >

<snip>

> > I'm not sure these 3 nodes should be removed. AFAIR, they
> were just slightly moved in lo branch.
>
> Even with the fixes above, ehci on my beagle xM/Panda still
> doesn't work
> with 2.6.37-next-20110106+, follows the failure messages:
>
> [   57.918182] bus: 'platform': really_probe: probing driver
ehci-omapwith device ehci-omap.0
> [   57.918243] ehci-omap ehci-omap.0: failed to get ehci port0 regulator
> [   57.918273] ehci-omap ehci-omap.0: failed to get ehci port1 regulator
> [   57.918304] ehci-omap ehci-omap.0: starting TI EHCI USB Controller
> [   57.918457] ehci-omap ehci-omap.0: OMAP UHH_REVISION 0x10
> [   57.918487] ehci-omap ehci-omap.0: TLL RESET DONE
> [   57.918487] ehci-omap ehci-omap.0: OMAP3 ES version > ES2.1
> [   57.918518] ehci-omap ehci-omap.0: UHH setup done, uhh_hostconfig=31c
> [   58.922302] ehci-omap ehci-omap.0: phy reset operation timed out
> [   59.930114] ehci-omap ehci-omap.0: phy reset operation timed out
> [   59.930145] ehci-omap ehci-omap.0: reset hcs_params 0x1313 dbg=0 cc=1
pcc=3 ordered ports=3
> [   59.930175] ehci-omap ehci-omap.0: reset hcc_params 0016 thresh 1
uframes 256/512/1024 park
> [   59.930206] ehci-omap ehci-omap.0: OMAP-EHCI Host Controller
> [   59.936218] drivers/usb/core/inode.c: creating file 'devices'
> [   59.936279] drivers/usb/core/inode.c: creating file '001'
>
> Any ideas?
>

I'll take a look in a short while. I don't have an XM to
test, so you'll have to help me out here.

- Anand
