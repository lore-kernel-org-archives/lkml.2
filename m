Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1HYRIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:08:22 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:14522
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938Ab1HYRIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:08:21 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz936eK1432N98dK4015Lzz1202hzz15d4Rz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQHU5V-01-0R9-02
X-M-MSG: 
Date: Thu, 25 Aug 2011 19:05:34 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/8] iommu: move IOMMU specific code to intel-iommu.c
Message-ID: <20110825170534.GL1923@amd.com>
References: <20110824000517.710353624@sbsiddha-desk.sc.intel.com>
 <20110824001456.282401285@sbsiddha-desk.sc.intel.com>
 <20110824092700.GF2079@amd.com>
 <1314210701.16133.13.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314210701.16133.13.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:31:40PM -0400, Suresh Siddha wrote:
> On Wed, 2011-08-24 at 02:27 -0700, Roedel, Joerg wrote:
> > On Tue, Aug 23, 2011 at 08:05:20PM -0400, Suresh Siddha wrote:
> > > +static void __init dmar_register_rmrr_unit(struct dmar_rmrr_unit *rmrr)
> > > +int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
> > > +int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
> > > +int dmar_find_matched_atsr_unit(struct pci_dev *dev)
> > > +int dmar_parse_rmrr_atsr_dev(void)
> > 
> > If these functions are not DMAR specific, how about replacing the dmar_
> > prefix too while at it?
> 
> These parsing functions are APCI DMAR table specific and are used only
> by intel-iommu routines. Because of this I didn't change their names but
> just moved to intel-iommu.c to cleanup some of the ifdef's in the common
> dmar.c code (specific to handling common ACPI DMAR tables etc) shared by
> both DMA-remapping (iommu) and IRQ-remapping.

Okay, should be fine then.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

