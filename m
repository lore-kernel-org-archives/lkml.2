Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0IMS24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:28:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60267 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0IMS2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kVKrf+zYu28uoGDsVlr4qiHGkhL41+ioFgWUh4IKlyEqrBwASApKvqiluCSEJcYtdt
         kBd+kB4eRc3jnGWBs7/FB5XefBdaJKEdP6NRNFrvfIH1UnX3phsQHpwIVIrtMQjXm/95
         2IQkqLH4Q7ujeYJ1Josx6OWIwiFCeDfEpb8aQ=
MIME-Version: 1.0
In-Reply-To: <20100913172606.GA14462@sig21.net>
References: <AANLkTi=tWwaFHB0DY=j0UaqbYdYJpGJpmWdGC4aMufSw@mail.gmail.com>
	<20100913121247.GA4003@sig21.net>
	<AANLkTiksacwuOwqJGZ0F3M1jhZ6Srr88wbfBQodOGOAt@mail.gmail.com>
	<20100913172606.GA14462@sig21.net>
Date: Mon, 13 Sep 2010 20:28:54 +0200
Message-ID: <AANLkTinzchkOZ67+wVXejLb+UqLRCu+zrzVB4j5zG2_w@mail.gmail.com>
Subject: Re: ARM target not boot after remap memory
From: Robin Theunis <robint91@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __log_buf

<5>Linux version 2.6.34.1robin9200v1.0 (robin@pc-robin) (gcc version
4.3.5 (Buildroot 2010.08) ) #36 Mon Sep 13 15:18:08 CEST 2010
<4>CPU: ARM920T [41129200] revision 0 (ARMv4T), cr=c0007177
<4>CPU: VIVT data cache, VIVT instruction cache
<4>Machine configuration botched (nr 251), unable to continue.

I don't understand it. What does it means? I have my mach types setup correctly.

Robin

2010/9/13 Johannes Stezenbach <js@sig21.net>:
> On Mon, Sep 13, 2010 at 04:30:17PM +0200, Robin Theunis wrote:
>>
>> I have compiled  the kernel with early printk on and debug_LL, It still
>> doesn't nothing after that line.
>
> Please don't top-post.
>
> Did you add "earlyprintk" to your kernel command line
> like the EARLY_PRINTK menuconfig help text suggests?
>
> arch/arm/mach-at91/include/mach/debug-macro.S also suggests
> the LL debug output goes to AT91 debug unit not to normal UART
> (not sure about this, I don't know much about AT91).
> Did you try to dump __log_buf using JTAG?
>
>
> HTH
> Johannes
>
