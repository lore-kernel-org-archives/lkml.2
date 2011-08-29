Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1H2MZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 08:25:30 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:33022
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752896Ab1H2MZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 08:25:25 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371K1432N98dKzz1202hzz15d4R8275bhz32i668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQOVU6-01-8PL-02
X-M-MSG: 
Date: Mon, 29 Aug 2011 14:25:16 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] iommu: Remove stub functions for !CONFIG_IOMMU_API
Message-ID: <20110829122516.GB9730@amd.com>
References: <1314364839-28492-1-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbaiNxo_226Zp9BZpgUjYFajnvgPPCjCOYP2Tj4pkWTwVA@mail.gmail.com>
 <20110829101550.GT1923@amd.com>
 <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CADMYwHwZPiH12HxOP952-Znm_+uMXKpj2M6ew8W-frZ7R8EcWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 06:59:05AM -0400, Ohad Ben-Cohen wrote:
> On Mon, Aug 29, 2011 at 1:15 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > Isn't the abstraction that the drivers use the dma-api? There should be
> > an implementation that doesn't require the iommu-api for such devices,
> > no?
> 
> Before we boot a remote processor device we often need to map it to
> some (specific) bus addresses (e.g. to allow the processor access to
> certain peripheral devices), and we're doing it directly with the
> IOMMU API.
> 
> Do you think this kind of functionality should be added to the DMA API as well ?
> 
> IIRC, it was suggested awhile ago but you supported using the IOMMU
> API directly in this case.

Right, when the system has an iommu then the iommu-api is the right
choice to do that. But how to you handle this on systems without an
iommu?

	Joerg


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

