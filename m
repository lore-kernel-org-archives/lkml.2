Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0EGS6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:58:34 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:60957 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131Ab0EGS6d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:58:33 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Steven Liu <lingjiujianke@gmail.com>,
       "nigel@tuxonice.net" <nigel@tuxonice.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 7 May 2010 20:57:39 +0200
Subject: RE: [PATCH] Check kmalloc return value before use the buffer
Thread-Topic: [PATCH] Check kmalloc return value before use the buffer
Thread-Index: AcrtylwgOSvPMQjqRmOLIf9nS14tUAATKy0A
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A68D366@EXDCVYMBSTM006.EQ1STM.local>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>
	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>
	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
	 <4BE3DF5A.9070601@tuxonice.net>
 <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com>
In-Reply-To: <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Steven]

> the code in arch/arm/mach-u300/dummyspichip.c is
> 
>     bigtxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>     if (bigtxbuf_virtual == NULL) {
>         status = -ENOMEM;
>         goto out;
>     }
>     bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
> 
> 
> if kmalloc memory space for bigrxbuf_virtual is NULL, when it have
> kmalloc DMA_TEST_SIZE memory space for bigtxbuf_virtual,so ,if kmalloc
> memory for bigtxbuf_virtual success and kmalloc memory for
> bigrxbuf_virtual faild,i think we must kfree  bigtxbuf_virtual memory

Ha, I also misread tx for rx, sorry.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
