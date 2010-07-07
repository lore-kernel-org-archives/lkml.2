Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0GGSIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:08:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:48631 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab0GGSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:08:05 -0400
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4C34BDCD.9080607@intel.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
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
	 <1278324973.16975.68.camel@localhost>
	 <AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	 <1278463901.20082.34.camel@dwillia2-linux>
	 <1278474039.31393.8.camel@localhost>  <4C34BDCD.9080607@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 19:07:56 +0100
Message-ID: <1278526076.5008.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 10:47 -0700, Dan Williams wrote:
> Chris this change will make the driver's dma mapping calls succeed which 
> means we once again need to be prepared for the case where the engine's 
> iommu is not configured correctly. 

It ought to succeed but do nothing -- just return the physical address
as if you have no IOMMU (which for this device you don't).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

