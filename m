Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0EGJvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:51:44 -0400
Received: from crca.org.au ([74.207.252.120]:32974 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab0EGJvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:51:43 -0400
X-Bogosity: Ham, spamicity=0.000002
Message-ID: <4BE3E2AB.9030107@tuxonice.net>
Date: Fri, 07 May 2010 19:51:39 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Liu <lingjiujianke@gmail.com>
CC: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com>	 <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local>	 <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>	 <4BE3DF5A.9070601@tuxonice.net> <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com>
In-Reply-To: <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 07/05/10 19:47, Steven Liu wrote:
> Hi, guy,
>
> the code in arch/arm/mach-u300/dummyspichip.c is
>
>      bigtxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>      if (bigtxbuf_virtual == NULL) {
>          status = -ENOMEM;
>          goto out;
>      }
>      bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
>
>
> if kmalloc memory space for bigrxbuf_virtual is NULL, when it have
> kmalloc DMA_TEST_SIZE memory space for bigtxbuf_virtual,so ,if kmalloc
> memory for bigtxbuf_virtual success and kmalloc memory for
> bigrxbuf_virtual faild,i think we must kfree  bigtxbuf_virtual memory

Ah, I see. I misread. Humble apologies :)

The other point still applies: You need to add a commit comment - even a 
simple one.

Regards,

Nigel
