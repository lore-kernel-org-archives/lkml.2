Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1GDILN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:11:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37949 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab1GDILK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:11:10 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4E0DAB90.9080708@mvista.com>
References: <1309509472.30642.1.camel@phoenix> <4E0DAB90.9080708@mvista.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 4 Jul 2011 16:10:50 +0800
Message-ID: <CAF+7xW=7PM2+e1xxqfL++NGaCZjA3JoHn11vCrcK05+CVBjN7w@mail.gmail.com>
Subject: Re: [PATCH] ARM: DMA: Add missing semicolon for the define of dma_alloc_area
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/1 Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 01-07-2011 12:37, Axel Lin wrote:
>
>> I got below build error by: make at91x40_defconfig;make
>> Fix it by adding a missing semicolon for the define of dma_alloc_area.
>
>>   CC      arch/arm/mm/dma-mapping.o
>> arch/arm/mm/dma-mapping.c:309: warning: 'struct dma_coherent_area'
>> declared inside parameter list
>> arch/arm/mm/dma-mapping.c:309: warning: its scope is only this definition
>> or declaration, which is probably not what you want
>> arch/arm/mm/dma-mapping.c: In function '__dma_alloc':
>> arch/arm/mm/dma-mapping.c:324: error: expected ';' before '}' token
>> arch/arm/mm/dma-mapping.c: At top level:
>> arch/arm/mm/dma-mapping.c:334: warning: 'struct dma_coherent_area'
>> declared inside parameter list
>> arch/arm/mm/dma-mapping.c:374: warning: 'struct dma_coherent_area'
>> declared inside parameter list
>> make[1]: *** [arch/arm/mm/dma-mapping.o] Error 1
>> make: *** [arch/arm/mm] Error 2
>
>   You didn't fix the warning though, so not clear why you cited them....
Because it's a copy-paste from the output of make.
I just think I should not manually edit the log.

Well, a patch to fix the warning is on the way.

Regards,
Axel
