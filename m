Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1KHQXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:23:23 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:47983
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab1KHQXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:23:22 -0500
X-SpamScore: -23
X-BigFish: VPS-23(zz9371K1431J1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LUCO6O-02-475-02
X-M-MSG: 
Date: Tue, 8 Nov 2011 17:23:11 +0100
From: Joerg Roedel <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <iommu@lists.linux-foundation.org>, <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: Re: [PATCH v4 0/7] iommu: split mapping to page sizes as supported
 by the hardware
Message-ID: <20111108162311.GB5182@amd.com>
References: <1318850846-16066-1-git-send-email-ohad@wizery.com>
 <CAK=Wgbb5K+rqPNdM2sC8z+9d4-hdcPwV-vXk6gcAYWaO+dVx3w@mail.gmail.com>
 <20111108140133.GD2113@amd.com>
 <CAK=WgbYiF04i8XRkn+YQhd=z6uDRwr8JEiWP1CLFLjM7Y+xWKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbYiF04i8XRkn+YQhd=z6uDRwr8JEiWP1CLFLjM7Y+xWKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:03:09PM +0200, Ohad Ben-Cohen wrote:
> On Tue, Nov 8, 2011 at 4:01 PM, Joerg Roedel <Joerg.Roedel@amd.com> wrote:
> > On Tue, Nov 08, 2011 at 02:57:02PM +0200, Ohad Ben-Cohen wrote:
> >> Joerg, gentle reminder. thanks.
> >
> > Just wanted to wait until -rc1 is out and I can start merging
> > new stuff :)
> 
> np, thanks :)

Does not apply cleanly. Can you please rebase against v3.2-rc1 and
resend?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

