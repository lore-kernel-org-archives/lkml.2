Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0CYWLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:11:45 -0400
Received: from bu3sch.de ([62.75.166.246]:56222 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0CYWLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:11:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?J=C3=A9r=C3=B4me_Oufella?= 
	<jerome.oufella@savoirfairelinux.com>
Subject: Re: gpiolib: irq functions not implemented on x86
Date: Thu, 25 Mar 2010 23:11:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33; KDE/4.3.4; ppc; ; )
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <566941124.2751269545764521.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <566941124.2751269545764521.JavaMail.root@mail.savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003252311.22522.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are you sure that I am the intended recipient of this mail?

I'm not involved in the GPIO subsystem at all.


On Thursday 25 March 2010 20:36:04 Jérôme Oufella wrote:
> Hi,
> 
> I wrote a gpiolib implementation for Technologic Systems TS-5500 boards (x86)
> custom GPIO lines. Some of their GPIO lines are directly hooked to CPU (ElanSC520)
> GPIRQ lines, so they can trigger IRQs.
> 
> However, looking at arch/x86/include/asm/gpio.h:
> /*
>  * Not implemented, yet.
>  */
> static inline int gpio_to_irq(unsigned int gpio)
> {
>         return -ENOSYS;
> }
> 
> gpio_to_irq()/irq_to_gpio() are not defined on x86 yet.
> 
> Q: Is there a reason not to have it call gpiolib's __gpio_to_irq(), as done 
> for other gpiolib functions defined here ? such as
> 
> -       return -ENOSYS;
> +       return __gpio_to_irq(gpio);
> 
> 
> Thanks
> Jerome Oufella
> 
> 

-- 
Greetings, Michael.
