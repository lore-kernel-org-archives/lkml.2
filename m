Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2A0OFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:05:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42601 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2A0OFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:05:40 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3807@EXMAIL03.scwf.nsc.com>
References: <AczYZ9LHrvHWLbKwTyaqeFikntXMDQ==>
	<B567DBAB974C0544994013492B949F8E3812CD3807@EXMAIL03.scwf.nsc.com>
Date: Fri, 27 Jan 2012 15:05:40 +0100
Message-ID: <CACRpkdZ6gGZjOw0FxL3dbvgDQ9VsbJYmgxkferkFNVcz3pzPPg@mail.gmail.com>
Subject: Re: [PATCH 2/4] leds-lp5521: add 'update_config' in the lp5521_platform_data
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 7:09 PM, Kim, Milo <Milo.Kim@ti.com> wrote:

> The value of CONFIG register(Addr 08h) is configurable.
> For supporting this feature, update_config is added in the platform data.
> If 'update_config' is not defined, the default value is
> 'LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT'.
>
> To define CONFIG register in the platform data, the bit definitions were moved
> to the header file.
>
> Documentation updated : description about 'update_config' and example.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Looks useful, plus you obviously was careful not to impact on
existing users, well done.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
