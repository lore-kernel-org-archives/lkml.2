Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1HXJ1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:27:15 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:6924 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1HXJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:27:14 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz98dKzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQFE96-02-7XY-02
X-M-MSG: 
Date: Wed, 24 Aug 2011 11:27:00 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "youquan.song@intel.com" <youquan.song@intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/8] iommu: move IOMMU specific code to intel-iommu.c
Message-ID: <20110824092700.GF2079@amd.com>
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
 <20110824001456.282401285@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110824001456.282401285@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 08:05:20PM -0400, Suresh Siddha wrote:
> +static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
> +int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
> +int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
> +int dmar_find_matched_atsr_unit(struct pci_dev *dev)
> +int dmar_parse_rmrr_atsr_dev(void)

If these functions are not DMAR specific, how about replacing the dmar_
prefix too while at it?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

