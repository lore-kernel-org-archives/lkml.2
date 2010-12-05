Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab0LEQvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 11:51:23 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63597 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174Ab0LEQvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 11:51:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=mQOTgIgImhvDYssfHu/isjjRbsaa8lF2kelGJ/jrrysowGUDDqV0WZcbvFIvAd7Cxy
         +KdGhXJlOB4L2g0qr2AxVVLo/xllKcxqOQDzFnTb4Dr3SeCBcvQ5122C6hWKoqUV0uhq
         48SkR/lwxT7bLUKpCcufdF48TBV4vEZ3Q4Wh8=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <20101205081108.9bdb7504.randy.dunlap@oracle.com>
References: <20101204135732.GA12774@sepie.suse.cz>
	<AANLkTimeyo==XJWUaUs8EzJvA8azkk3sw9FXQhMjuo6M@mail.gmail.com>
	<20101205081108.9bdb7504.randy.dunlap@oracle.com>
Date: Sun, 5 Dec 2010 16:51:20 +0000
Message-ID: <AANLkTimm1Xn4wwNAoDJ4hjnOmBOnxBgcsCzVEJTEag97@mail.gmail.com>
Subject: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5
From: trapDoor <trapdoor6@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, lacombar@gmail.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 4:11 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sun, 5 Dec 2010 15:42:46 +0000 trapDoor wrote:
>
>> Hello,
>> I couldn't wait and I merged the changes into my copy of mainline
>> tree. The merge was successful, no conflicts and the merge-diffstat
>> was exactly the same as above. However, when  running oldconfig on the
>> patched kernel I still get lots of warnings:
>>
>> warning: (GPIO_RDC321X && PCI && GPIOLIB) selects MFD_RDC321X which
>> has unmet direct dependencies (MFD_SUPPORT && PCI)
>> warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI ||
>> GPIO_VX855 && GPIOLIB || GPIO_RDC321X && PCI && GPIOLIB ||
>> MFD_88PM860X && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_ASIC3
>> && MFD_SUPPORT && GENERIC_HARDIRQS && GPIOLIB && ARM ||
>> MFD_SH_MOBILE_SDHI && MFD_SUPPORT && (SUPERH || ARCH_SHMOBILE) ||
>> MFD_DAVINCI_VOICECODEC && MFD_SUPPORT || HTC_PASIC3 && MFD_SUPPORT ||
>> TPS6507X && MFD_SUPPORT && I2C || TWL4030_CODEC && MFD_SUPPORT &&
>> TWL4030_CORE || MFD_STMPE && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS
>> || MFD_TC35892 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS ||
>> MFD_T7L66XB && MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6387XB &&
>> MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6393XB && MFD_SUPPORT &&
>> GPIOLIB && ARM || MFD_MAX8925 && MFD_SUPPORT && I2C=y &&
>> GENERIC_HARDIRQS || MFD_MAX8998 && MFD_SUPPORT && I2C=y &&
>> GENERIC_HARDIRQS || MFD_WM8400 && MFD_SUPPORT && I2C || MFD_WM831X_I2C
>> && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_WM831X_SPI &&
>> MFD_SUPPORT && SPI_MASTER && GENERIC_HARDIRQS || MFD_WM8994 &&
>> MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_MC13XXX && MFD_SUPPORT
>> && SPI_MASTER || AB3100_CORE && MFD_SUPPORT && I2C=y && ABX500_CORE ||
>> AB8500_CORE && MFD_SUPPORT && GENERIC_HARDIRQS && ABX500_CORE &&
>> SPI_MASTER && ARCH_U8500 || AB3550_CORE && MFD_SUPPORT && I2C=y &&
>> GENERIC_HARDIRQS && ABX500_CORE || MFD_TIMBERDALE && MFD_SUPPORT &&
>> PCI && GPIOLIB || LPC_SCH && MFD_SUPPORT && PCI || MFD_RDC321X &&
>> MFD_SUPPORT && PCI || MFD_JANZ_CMODIO && MFD_SUPPORT && PCI ||
>> MFD_JZ4740_ADC && MFD_SUPPORT && MACH_JZ4740 || MFD_TPS6586X &&
>> MFD_SUPPORT && I2C=y && GPIOLIB && GENERIC_HARDIRQS || MFD_VX855 &&
>> MFD_SUPPORT && PCI) selects MFD_CORE which has unmet direct
>> dependencies (MFD_SUPPORT)
>>
>
> That's 2 warnings.  I have sent a patch for the first one.
> Looks like I need to resend it.
>

I was actually impressed by the amount of lines produced by those two
warnings :) I'd call it 'a lot'.

-- 
Thanks,
Tomasz
