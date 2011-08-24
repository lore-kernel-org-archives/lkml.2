Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1HXI24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:28:56 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:52277 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab1HXI2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:28:54 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zzbb2dK9371K1432N98dKzz1202hzz15d4Rz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQFBK2-01-2G1-02
X-M-MSG: 
Date: Wed, 24 Aug 2011 10:28:48 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "youquan.song@intel.com" <youquan.song@intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 8/8] iommu: rename the DMAR and INTR_REMAP config options
Message-ID: <20110824082848.GZ2079@amd.com>
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
 <20110824001456.558630224@sbsiddha-desk.sc.intel.com>
 <4E549E9B.7080004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E549E9B.7080004@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:47:55AM -0400, Yinghai Lu wrote:
> On 08/23/2011 05:05 PM, Suresh Siddha wrote:
> > Change the CONFIG_DMAR to CONFIG_INTEL_IOMMU to be consistent with the other
> > IOMMU options.
> > 
> > Rename the CONFIG_INTR_REMAP to CONFIG_IRQ_REMAP to match the irq
> > subsystem name.
> > 
> > And define the CONFIG_DMAR_TABLE for the common ACPI DMAR routines
> > shared by both CONFIG_INTEL_IOMMU and CONFIG_IRQ_REMAP.
> 
> is there something like IRQ_REMAP from AMD?

Yes there is. And I digged already through the existing VT-d code to see
how it can be implemented side by side. Doesn't seem easy but should be
doable. And it is on my list for the not too-distant future.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

