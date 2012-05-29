Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2E2Hxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 03:53:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42206 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2E2Hxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 03:53:51 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4FC47CEB.8090106@linaro.org>
References: <1338272340.3127.1.camel@phoenix> <4FC47CEB.8090106@linaro.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 29 May 2012 15:53:30 +0800
Message-ID: <CAF+7xWnriCRAuGzTusrtCkYTyUNPKVXE_f0kwysNJ3=AkuzvvA@mail.gmail.com>
Subject: Re: [PATCH] mfd: Remove config AB8500_I2C_CORE Kconfig entry
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/29 Lee Jones <lee.jones@linaro.org>:
> On 29/05/12 14:19, Axel Lin wrote:
>>
>> config AB8500_I2C_CORE is not used after commit d28f1db
>> "mfd: Remove confusing ab8500-i2c file and merge into ab8500-core".
>> Thus remove it.
>>
>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>
>
> I have this patch embedded into a patch-set I'm going to send to ARM-SoC for
> inclusion into -rc1 this afternoon. Would you mind leaving this one?

I don't mind.
But AFAIK, commit d28f1db is in mfd tree.
Any reason you want to send the patch to ARM-SoC instead of mfd tree.

Regards,
Axel
