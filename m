Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2AZLxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:53:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab2AZLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3F53@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812CD3E37@EXMAIL03.scwf.nsc.com>
	<4F1FB4DA.2050104@metafoo.de>
	<B567DBAB974C0544994013492B949F8E3812CD3F53@EXMAIL03.scwf.nsc.com>
Date: Thu, 26 Jan 2012 12:53:45 +0100
Message-ID: <CACRpkdZN2GAnntROEC2iOaz7NYsipUiuFAq3v_bKgJEAjOJm+A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] leds-lm3530: set the value of max_brightness to 127
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 10:40 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> Only 7 bits are used for the brightness. (register address : A0h)
> So the max_brightness property of lm3530 should be set to 127.
>
> On initializing registers, maximum initial brightness is limited to 'max_brightness'.
>
> Division-by-two is removed on updating the value of brightness.
> This arithmetic is not necessary because the range of brightness is 0 ~ 127.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

On *this* exact patch.

Yours,
Linus Walleij
