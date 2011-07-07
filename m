Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1GGJ7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:59:39 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:11445
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751136Ab1GGJ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:59:38 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz4015L1432N98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNYJR7-02-0SL-02
X-M-MSG: 
Date: Thu, 7 Jul 2011 11:59:30 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [git pull] IOMMU updates for 3.1
Message-ID: <20110707095930.GD1956@amd.com>
References: <20110707085359.GC1956@amd.com>
 <20110707094558.GB15058@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110707094558.GB15058@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 05:45:58AM -0400, Ingo Molnar wrote:
> Fails to build with INTR_REMAP=y && CONFIG_DMAR=n:
> 
>  arch/x86/built-in.o: In function `lapic_resume':
>  apic.c:(.text+0x16329): undefined reference to `intr_remapping_enabled'
>  apic.c:(.text+0x1651d): undefined reference to `intr_remapping_enabled'
>  apic.c:(.text+0x1652b): undefined reference to `reenable_intr_remapping'
>  [...]
> 
> config attached.

Thanks, I'll look into it.

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

