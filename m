Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1FNMs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:48:29 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:57725 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab1FNMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:48:26 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zz9371M4015L1432N98dKzz1202hzz15d4R8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMS68J-01-6ZJ-02
X-M-MSG: 
Date: Tue, 14 Jun 2011 14:48:46 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] drivers/iommu/ relocations
Message-ID: <20110614124846.GA6689@amd.com>
References: <1307742947-32118-1-git-send-email-ohad@wizery.com>
 <20110614102916.GF29908@amd.com>
 <BANLkTinABOiqzhY_FfCeQLyE53Wr=OtAeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTinABOiqzhY_FfCeQLyE53Wr=OtAeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 06:44:56AM -0400, Ohad Ben-Cohen wrote:
> On Tue, Jun 14, 2011 at 1:29 PM, Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> > Btw, what tree do these patches apply against?
> 
> v3.0-rc2
> 
> > I tried to apply them to v3.0-rc3 and got conflicts.
> 
> What kind of conflicts ? I just tried rc3 and it applied cleanly.
> 
> Just in case, I'm attaching the patches too.
> 
> Tell me if you still see any issue, thanks !

The patches from your archive applied fine. Probably the ones I got were
screwed up by exchange :/

I go forward an test them now.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

