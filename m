Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab0F3UCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 16:02:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:39889 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab0F3UCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:02:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,514,1272870000"; 
   d="scan'208";a="531906767"
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <David.Woodhouse@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C2B9DAC.1030806@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C29420D.2010406@intel.com>
	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost>  <4C2B9DAC.1030806@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation
Date: Wed, 30 Jun 2010 21:02:05 +0100
Message-ID: <1277928125.18854.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 20:40 +0100, Williams, Dan J wrote:
>  From the dmesg:
> > IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900000c2f0462 ecap e01
> > DMAR: DRHD base: 0x000000fe714000 flags: 0x0
> > IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900000c2f0462 ecap e01
> > DMAR: DRHD base: 0x000000fe719000 flags: 0x0
> > IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900000c2f0462 ecap e01
> > DMAR: DRHD base: 0x000000fe718000 flags: 0x1
> > IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900000c2f0462 ecap e01
> 
> Where we expect bit 54 to be set for the DMA iommu, and it does not 
> appear to show up.

So the BIOS is lying to us about which PCI devices are attached to which
IOMMU?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

