Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2A0OIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:08:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46424 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2A0OIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:08:45 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3809@EXMAIL03.scwf.nsc.com>
References: <AczYZ9hWemTkved3RqKuOuMCSoz1+Q==>
	<B567DBAB974C0544994013492B949F8E3812CD3809@EXMAIL03.scwf.nsc.com>
Date: Fri, 27 Jan 2012 15:08:44 +0100
Message-ID: <CACRpkdbTm1VoaOZMYysEKzOtoF3ZJvWWHNGBMqeaEF1=krPVyA@mail.gmail.com>
Subject: Re: [PATCH 4/4] leds-lp5521: redefinition of register bits
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 7:09 PM, Kim, Milo <Milo.Kim@ti.com> wrote:

> For better readability, values of LP5521_REG_ENABLE register were redefined.
> Additional definitions: LP5521_ENABLE_DEFAULT and LP5521_ENABLE_RUN_PROGRAM.
>
> Use definition rather than hard code value.
> : 0x3F -> 'LP5521_CMD_DIRECT'
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Looks like a good idea.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
