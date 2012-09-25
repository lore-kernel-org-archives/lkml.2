Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2IYKQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:16:49 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:7790
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753105Ab2IYKQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:16:47 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zzbb2dI98dI9371I936eI1432I4015I14ffIzz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAWHVH-02-1OQ-02
X-M-MSG: 
Date: Tue, 25 Sep 2012 12:16:28 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <iommu@lists.linux-foundation.org>, <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Sept 24 (iommu)
Message-ID: <20120925101628.GX2505@amd.com>
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au>
 <5060D876.5030209@xenotime.net>
 <1348543405.2320.146.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1348543405.2320.146.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 09:23:25PM -0600, Alex Williamson wrote:
> On Mon, 2012-09-24 at 15:02 -0700, Randy Dunlap wrote:
> > On 09/24/2012 07:53 AM, Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Today was a train wreck, with lots of new conflicts across several trees
> > > and a few build failures as well.
> > > 
> > > Changes since 201209021:
> > > 
> > 
> > 
> > 
> > on i386:
> > 
> > drivers/built-in.o: In function `iommu_group_remove_device':
> > (.text+0x74cb10): multiple definition of `iommu_group_remove_device'
> > arch/x86/built-in.o:(.text+0x140d0): first defined here
> ...
> 
> 
> Here's a patch to get it past this.  It still doesn't fully build, but
> the rest isn't iommu related.  Thanks,

Applied, thanks.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

