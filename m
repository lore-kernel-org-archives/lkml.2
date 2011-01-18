Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab1ARBoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:44:20 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:45703 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab1ARBoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:44:19 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
Date: Tue, 18 Jan 2011 09:43:45 +0800
Message-ID: <4C79549CB6F772498162A641D92D5328D9FE16@penmb01.corp.atmel.com>
In-Reply-To: <4D34C5BF.2070107@bluewatersys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
Thread-Index: Acu2l8TofDjz1Wc4TweWzOBhsM7EfgAFz+bg
References: <hong.xu@atmel.com> <1295248809-30334-2-git-send-email-hong.xu@atmel.com> <4D34A37E.1060300@bluewatersys.com> <4D34C5BF.2070107@bluewatersys.com>
From: "Xu, Hong" <Hong.Xu@atmel.com>
To: "Ryan Mallon" <ryan@bluewatersys.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <jamie@jamieiles.com>,
        <jacmet@sunsite.dk>, "Nicolas Ferre" <nicolas.ferre@atmel.com>
X-OriginalArrivalTime: 18 Jan 2011 01:43:48.0294 (UTC) FILETIME=[2694BE60:01CBB6B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,
> -----Original Message-----
> From: Ryan Mallon [mailto:ryan@bluewatersys.com]
> Sent: Tuesday, January 18, 2011 6:42 AM
> To: Xu, Hong
> Cc: linux-mtd@lists.infradead.org; linux-arm-kernel@lists.infradead.org;
> linux-kernel@vger.kernel.org; jamie@jamieiles.com; jacmet@sunsite.dk;
> Ferre, Nicolas
> Subject: Re: [PATCH] MTD: atmel_nand: Add DMA support to access Nandflash
> 
> root@snapper:~$ dmesg | grep -i dma
> [    0.850000] atmel_nand atmel_nand: Failed to request DMA channel
> [    0.860000] atmel_nand atmel_nand: No DMA support for NAND access.
> [    1.530000] at_hdmac at_hdmac: Atmel AHB DMA Controller ( cpy slave ),
> 8 channels
> 
> 
> It looks like the registration for the DMA controller happens after the
> NAND driver probe and so the request is failing. I had a quick look, but
> I can't see anything that would change this in more recent kernels. Any
> ideas?
> 
You got the point. A [Git Pull] has been sent, see
http://article.gmane.org/gmane.linux.kernel/1088240/match=dmaengine+update

In this patch, subsys_initcall will be used so DMA engine will be initialized before NAND driver.
Thanks.

BR,
Hong
