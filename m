Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1FHNfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:35:43 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:5106
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754902Ab1FHNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:35:41 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz9371M1418M1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMH4F7-01-9CK-02
X-M-MSG: 
Date: Wed, 8 Jun 2011 15:35:55 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Matthew Wilcox <matthew@wil.cx>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 0/4] drivers/iommu/ relocations
Message-ID: <20110608133555.GC21591@amd.com>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
 <20110608130522.GC29089@parisc-linux.org>
 <BANLkTin5JYt4=gru181N_BuvnHB7kUTUeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTin5JYt4=gru181N_BuvnHB7kUTUeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 09:11:16AM -0400, Ohad Ben-Cohen wrote:
> On Wed, Jun 8, 2011 at 4:05 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> > You've missed at least parisc, ia64, alpha, sparc, powerpc and sh which
> > have IOMMUs.
> 
> None of these seem to call register_iommu.
> 
> > Not that they necessarily all need to be moved across in
> > one patchset, but saying "all iommu drivers" is clearly false.
> 
> I've moved only the existing IOMMU API users.

And I think that is good for now. The iommu-api needs to be extended to
cover all kinds of iommus (like the iommus available on other
architectures). It is definitly the plan to do that and have a common
dma_ops implementation for all of them. But lets start small by now and
move forward step by step :-)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

