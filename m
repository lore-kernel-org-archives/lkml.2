Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2LJKEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:04:12 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56280 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2LJKEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:04:10 -0500
MIME-Version: 1.0
In-Reply-To: <20121207164906.08b65046@pyramind.ukuu.org.uk>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
	<CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
	<20121207145955.GA28704@roeck-us.net>
	<20121207164906.08b65046@pyramind.ukuu.org.uk>
Date: Mon, 10 Dec 2012 11:04:09 +0100
Message-ID: <CACRpkdY2qht8Yxs2gzjHoxxqcqOP_v=-73OBmNfyO0qr1n+7MQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Guenter Roeck <groeck-dsl@sbcglobal.net>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 5:49 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> I could imagine declaring the activity request buttons to be "input", but for
>> presence detects it is a bit far fetched and would add too much complexity.
>
> Android tries to address this with its switch class driver, but I'm not
> sure its actually got anything over making them input devices.

This has actually been merged into the kernel proper as drivers/extcon.

So another poke on Günther if this fulfills the needs?

Yours,
Linus Walleij
