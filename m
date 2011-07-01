Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1GALN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:13:29 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58708 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab1GALNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:13:24 -0400
Message-ID: <4E0DAB90.9080708@mvista.com>
Date: Fri, 01 Jul 2011 15:12:16 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: DMA: Add missing semicolon for the define of dma_alloc_area
References: <1309509472.30642.1.camel@phoenix>
In-Reply-To: <1309509472.30642.1.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-07-2011 12:37, Axel Lin wrote:

> I got below build error by: make at91x40_defconfig;make
> Fix it by adding a missing semicolon for the define of dma_alloc_area.

>    CC      arch/arm/mm/dma-mapping.o
> arch/arm/mm/dma-mapping.c:309: warning: 'struct dma_coherent_area' declared inside parameter list
> arch/arm/mm/dma-mapping.c:309: warning: its scope is only this definition or declaration, which is probably not what you want
> arch/arm/mm/dma-mapping.c: In function '__dma_alloc':
> arch/arm/mm/dma-mapping.c:324: error: expected ';' before '}' token
> arch/arm/mm/dma-mapping.c: At top level:
> arch/arm/mm/dma-mapping.c:334: warning: 'struct dma_coherent_area' declared inside parameter list
> arch/arm/mm/dma-mapping.c:374: warning: 'struct dma_coherent_area' declared inside parameter list
> make[1]: *** [arch/arm/mm/dma-mapping.o] Error 1
> make: *** [arch/arm/mm] Error 2

    You didn't fix the warning though, so not clear why you cited them....

> Signed-off-by: Axel Lin<axel.lin@gmail.com>

WBR, Sergei
