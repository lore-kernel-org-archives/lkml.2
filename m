Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2LARBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:01:05 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41358 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2LARBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:01:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121125083229.GB21091@core.coreip.homeip.net>
References: <1353590617-11466-1-git-send-email-lee.jones@linaro.org>
	<20121125083229.GB21091@core.coreip.homeip.net>
Date: Sat, 1 Dec 2012 18:01:01 +0100
Message-ID: <CACRpkdYXcC-5hFG+nLK7AT6m-htrivwuhm-HodBnO0LY6RgGfA@mail.gmail.com>
Subject: Re: [PATCH 1/2] input: gpio-keys: Disable hardware on suspend
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>, linux-input@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 9:32 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Nov 22, 2012 at 01:23:36PM +0000, Lee Jones wrote:
>> From: Jonas Aaberg <jonas.aberg@stericsson.com>
>>
>> Disable hardware if active when suspending if the hw can not
>> wake the system from suspend.
>
> How about below instead (needs the other patch I have just sent out)?

LooksGoodToMe(TM)

Acked-by.

Yours,
Linus Walleij
