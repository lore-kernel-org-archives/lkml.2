Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1EaNYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:24:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53349 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab1EaNYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:24:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=TRMeqgahwk6BtW3ZE92/4phSU/y8TsETT52GuAiSo4cXFt3edB4Fa0mlc6YA6No+VY
         nr2ekCUx/goGeVt7T1zmsGAGyuyUNWYhVqJAyjKMiY+5jEIU//r/GPGv8mIeHLxj/d+i
         CT3XhGmBAqdEylLBqjalDyz7ReKErifkS+sik=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110531131812.GP11352@atomide.com>
References: <1306846544.30148.1.camel@phoenix> <20110531131812.GP11352@atomide.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 31 May 2011 21:23:49 +0800
Message-ID: <BANLkTi=JtnWtoWUOytjcqqvYsQde_SLr9w@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: OMAP2: Add missing include of linux/gpio.h
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Syed Mohammed Khasim <x0khasim@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Steve Sakoman <steve@sakoman.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/31 Tony Lindgren <tony@atomide.com>:
> * Axel Lin <axel.lin@gmail.com> [110531 05:51]:
>> I got some build error like below while executing "make omap2plus_defconfig".
>>
>>   CC      arch/arm/mach-omap2/board-2430sdp.o
>> arch/arm/mach-omap2/board-2430sdp.c: In function 'omap_2430sdp_init':
>> arch/arm/mach-omap2/board-2430sdp.c:247: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
>> arch/arm/mach-omap2/board-2430sdp.c:247: error: (Each undeclared identifier is reported only once
>> arch/arm/mach-omap2/board-2430sdp.c:247: error: for each function it appears in.)
>>
>> This patch fixes the build error by include linux/gpio.h instead of mach/gpio.h.
>
> Does this happen with next?
Yes, I build the kernel with today's linux-next tree.
>
> Will queue as a fix anyways.
Thanks,
Axel
