Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2DJPGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:06:07 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:30803 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391Ab2DJPGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:06:05 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432N1a09J98dK148cMzz1202hzz15d4Rz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M29R9T-02-539-02
X-M-MSG: 
Date: Tue, 10 Apr 2012 17:05:50 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 00/10] vt-d irq_remap_ops patchset
Message-ID: <20120410150550.GB2428@amd.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 30, 2012 at 11:46:58AM -0700, Suresh Siddha wrote:
> Ingo,
> 
> Here is the Joerg's irq_remap_ops patchset updated for the latest -tip.
> Simplified some of the naming conventions to follow the irq_remapping
> terminology. There are still some "if (irq_remapping_enabled)" checks in
> io_apic.c that I would like to roll into the new io_apic_ops. I will
> look into that shortly.
> 
> Joerg Roedel (8):
>   iommu: Rename intr_remapping files to intel_intr_remapping
>   iommu/vt-d: Make intr-remapping initialization generic
>   iommu/vt-d: Convert missing apic.c intr-remapping call to remap_ops
>   iommu/vt-d: Convert IR ioapic-setup to use remap_ops
>   iommu/vt-d: Convert IR set_affinity function to remap_ops
>   iommu/vt-d: Convert free_irte into a remap_ops callback
>   iommu/vt-d: Convert MSI remapping setup to remap_ops
>   x86, iommu/vt-d: Clean up interfaces for interrupt remapping
> 
> Suresh Siddha (2):
>   iommu: rename intr_remapping references to irq_remapping
>   iommu: rename intr_remapping.[ch] to irq_remapping.[ch]

Suresh, Yinghai, many thanks for testing this and pushing it forward. I
really appreciate it.

Ingo, Have these patches been applied to -tip or are there further
problems to be solved?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

