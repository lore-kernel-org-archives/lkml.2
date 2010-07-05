Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0GEKQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 06:16:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:50143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0GEKQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:16:20 -0400
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Li <lkml@chrisli.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <4C29420D.2010406@intel.com>
	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost>	<4C2B9DAC.1030806@intel.com>
	 <1277928125.18854.0.camel@localhost>	<4C2BBACF.3080405@intel.com>
	 <1277965264.18854.16.camel@localhost>	<4C2C3B07.7050200@intel.com>
	 <1277968336.4945.3.camel@localhost>	<4C2C4319.6090906@intel.com>
	 <1277972137.12558.2.camel@localhost>	<4C2CCE67.6070600@intel.com>
	 <AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	 <AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 11:16:13 +0100
Message-ID: <1278324973.16975.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 20:00 +0100, Chris Li wrote:
> But I don't see the line that print out BIOS is lying.

Hrm. Want to augment the dmar_find_matched_drhd_unit() function to
_always_ print the DRHD returned for the offending PCI device? And if
that still doesn't show, make it print pdev->vendor, pdev->device and
the returned DRHD pointer for _every_ call?

-- 
dwmw2

