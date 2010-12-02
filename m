Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0LBCTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:19:12 -0500
Received: from wdscspam3.wdc.com ([129.253.55.42]:5986 "EHLO wdscspam3.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0LBCTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:19:10 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 21:19:10 EST
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="905328"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Change of Default kernel page size i.e 4KB
Date: Wed, 1 Dec 2010 18:09:48 -0800
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF20D606B@wdscexbe08.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Change of Default kernel page size i.e 4KB
Thread-Index: AcuReGPOm1q1/vChT56sfhGpdB2ijwATDBfA
References: <AANLkTi=4gtEC9fZyvc9g6uHecvjPrr0dDc==KsDOvq2Q@mail.gmail.com><20101201132437.GA32555@linux-mips.org> <AANLkTimEb32MAC_KUm+ZjXntJqiE=_OPbO6C3Se4MFEN@mail.gmail.com>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "naveen yadav" <yad.naveen@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Dec 2010 02:09:48.0750 (UTC) FILETIME=[FF452EE0:01CB91C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of naveen yadav
> Sent: Wednesday, December 01, 2010 8:53 AM
> To: linux-kernel@vger.kernel.org
> Subject: Change of Default kernel page size i.e 4KB
> 
> Hi all,
> 
>  I have few drivers and very big application running on ARM 
> and MIPS target.
>  I want to check the performance by changing the page size ie.
>  8K, 16K, 32K etc.
> 
>  Is it possile, If yes then what all care i need to take .
> 
> thanks
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

For processor families that have Linux support for other-than-4K page
sizes, you can use menuconfig to change the page size in "Kernel Options".

This changes the configuration items: PPC_*_PAGES, SPARC64_PAGE_SIZE_*,
(MIPS) PAGE_SIZE_*, IA64_PAGE_SIZE_*.
