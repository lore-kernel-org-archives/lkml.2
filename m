Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0LNGrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 01:47:12 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:64288 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab0LNGrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 01:47:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H+bccp3ezY8qatiGYhimLEK+eHsZPQm6pbIV5tZWodTJyUFeEN2zdvlcsj0xeLwmV8
         uXXTmuR1HBPwaliE8Nb4ZHzJh8/U8PjwnpKrqUf9bEx+rL69f0zru8AgAUccx5LukbG6
         GgmSgAbIGAubzmclItXTutfnb7y6CZMOwGt6g=
MIME-Version: 1.0
In-Reply-To: <20101213114332.GF6017@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de>
	<1291902441-24712-10-git-send-email-s.hauer@pengutronix.de>
	<AANLkTi=vT8pX1QQ6DjzQatceO-tQb3Zu90CRAVi2DcpZ@mail.gmail.com>
	<20101213114332.GF6017@pengutronix.de>
Date: Tue, 14 Dec 2010 14:47:08 +0800
Message-ID: <AANLkTimPpo5nJ2Bg_wZohgTuB1ypfqGJxvQSu5_2fKz2@mail.gmail.com>
Subject: Re: [PATCH 9/9] ARM i.MX51 babbage: Add framebuffer support
From: Liu Ying <liu.y.victor@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/13 Sascha Hauer <s.hauer@pengutronix.de>:
> On Sun, Dec 12, 2010 at 09:37:38AM +0800, Liu Ying wrote:
>> Hello, Sascha,
>>
>> I have following 3 comments to this patch:
>> 1) I think DISP1_DATx pins need not be set specially, as they keep the
>> default register values.
>
> We do not want to depend on default register values in the Linux Kernel.
[LY] Ok. Please add disp1 related pins configuration, including
DISP1_HSYNC, DISP1_VSYNC and DISP1_CLK.
       It will be fine to add disp2 related pins configuration also.
>
>> 2) Please define 'MX51_PAD_DI_GP4__IPU_DI2_PIN15' in
>> arch/arm/plat-mxc/include/mach/iomux-mx51.h, and rename the pin to be
>> 'MX51_PAD_DI_GP4__DI2_PIN15', as we name it according to the MX51
>> iomux reference manual.
>
> I'm not sure. Normally it's good practice to code the unit into the
> name. Otherwise we end up with names like MX51_PAD_xyz__TX which could
> be the tx pin of just about any unit.
>
>
>> 3) It is better to exchange the following two lines or just remove the
>> first line:
>> +       gpio_set_value(GPIO_DVI_RESET, 0);
>> +       gpio_direction_output(GPIO_DVI_RESET, 0);
>
> ok.
>
> Sascha
>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>
