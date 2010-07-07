Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab0GGDWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 23:22:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:58996 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0GGDWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 23:22:52 -0400
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
From: David Woodhouse <dwmw2@infradead.org>
To: Chris Li <lkml@chrisli.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <AANLkTikFo4wExHd3vF7biL3NDvHOekm-PuNV_-BeOVPS@mail.gmail.com>
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>
	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>
	 <4C2A8879.8010000@intel.com>
	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>
	 <4C2AC55E.3040303@intel.com>
	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com>
	 <1277923422.16256.8.camel@localhost> <4C2B9DAC.1030806@intel.com>
	 <1277928125.18854.0.camel@localhost> <4C2BBACF.3080405@intel.com>
	 <1277965264.18854.16.camel@localhost> <4C2C3B07.7050200@intel.com>
	 <1277968336.4945.3.camel@localhost> <4C2C4319.6090906@intel.com>
	 <1277972137.12558.2.camel@localhost> <4C2CCE67.6070600@intel.com>
	 <AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>
	 <AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>
	 <1278324973.16975.68.camel@localhost>
	 <AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>
	 <1278463901.20082.34.camel@dwillia2-linux>
	 <AANLkTilnrdghkK1y7vc2Zi0C7KMXHYXpI_whecRxTD_8@mail.gmail.com>
	 <4C33D123.4080209@intel.com>
	 <AANLkTikFo4wExHd3vF7biL3NDvHOekm-PuNV_-BeOVPS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Jul 2010 04:22:43 +0100
Message-ID: <1278472963.31393.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.4 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 18:03 -0700, Chris Li wrote:
> 
> Here is the new dmesg.
> 
> Chris
> 
> --00163646dc2e3280f2048ac1bd39
> Content-Type: application/octet-stream; name=dmesg
> Content-Disposition: attachment; filename=dmesg 

Btw, it'd be really helpful if you could attach those as text files and
inline so that they can just be read in the mailer rather than saved.

-- 
dwmw2

