Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2AWTIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:08:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2AWTIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:08:11 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812C6D0C8@EXMAIL03.scwf.nsc.com>
References: <AczXFUrrL01k3ofEQ2+29qOpmm0AEg==>
	<B567DBAB974C0544994013492B949F8E3812C6D0C8@EXMAIL03.scwf.nsc.com>
Date: Mon, 23 Jan 2012 20:08:10 +0100
Message-ID: <CACRpkdYBDVMEcvtpt9JP5qPM8D=Sirmq71aE-U9Yz9HxO7wLiA@mail.gmail.com>
Subject: Re: [PATCH 1/7] leds-lm3530: support pwm input mode
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 2:46 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> * add 'struct lm3530_pwm_data' in the platform data
>  The pwm data is the platform specific functions which generate the pwm.
>  The pwm data is only valid when brightness is pwm input mode.
>  Functions should be implemented by the pwm driver.
>  pwm_set_intensity() : set duty of pwm.
>  pwm_get_intensity() : get current duty of pwm.
>
> * brightness control by pwm
>  If the control mode is pwm, then brightness is changed by the duty of pwm.
>  So pwm platform function should be called in lm3530_brightness_set().
>
> * do not update brightness register when pwm input mode
>  In pwm input mode, brightness register is not used.
>  If any value is updated in this register, then the led will be off.
>
> * patched based on kernel 3.0.1
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Looks nice and clean to me,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Milo,
Linus Walleij
