Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab2A0ODC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:03:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50683 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2A0ODA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:03:00 -0500
MIME-Version: 1.0
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD3806@EXMAIL03.scwf.nsc.com>
References: <AczYZ8yVBSJYBleRQuSZif3IIM5wFA==>
	<B567DBAB974C0544994013492B949F8E3812CD3806@EXMAIL03.scwf.nsc.com>
Date: Fri, 27 Jan 2012 15:03:00 +0100
Message-ID: <CACRpkdYPMnTis6wwYYpXwFwVoVT3ckopPwKKDe6jw26eZFqQfg@mail.gmail.com>
Subject: Re: [PATCH 1/4] leds-lp5521: add 'name' in the lp5521_led_config
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 7:09 PM, Kim, Milo <Milo.Kim@ti.com> wrote:

> The name of each led channel can be configurable.
> For the compatibility, the name is set to default value(xx:channelN)
> when 'name' is not defined.
>
> * kernel patch based on 3.0.1
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
