Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1DQV6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 17:58:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56073 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1DQV6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 17:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tCTfw/UHvtFHGY0ly/AGrSS0oHuh+/gscL0T0k3KWEMqbmNItrbVOgvUEcDptNbPF8
         LUaJPXOZgvbPdVBqADvHNdYoPi5iQ4HrHS6k9Qm0qYY7zX2L89TKsaKEmvzLauVsFTW/
         irYBuaQJnxKR5ty//YdqT+0azgKIUStRtyBnI=
MIME-Version: 1.0
In-Reply-To: <20110417224816.38ddffee@lxorguk.ukuu.org.uk>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<20110417224816.38ddffee@lxorguk.ukuu.org.uk>
Date: Sun, 17 Apr 2011 23:58:16 +0200
X-Google-Sender-Auth: RewqGStcIR-hNCy8hUuyyso_YlU
Message-ID: <BANLkTimwbsmQw0Dawz_+LpVf+wU60AbB0g@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/17 Alan Cox <alan@lxorguk.ukuu.org.uk>:

>> + * enum gpio_drive - drive modes for GPIOs (output)
>> + * @GPIO_DRIVE_PUSH_PULL: the GPIO will be driven actively high and low, this
>> + *   is the most typical case and is typically achieved with two active
>> + *   transistors on the output
>> + * @GPIO_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain (open
>> + *   collector) which means it is usually wired with other output ports
>> + *   which are then pulled up with an external resistor
>> + * @GPIO_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
>> + *   (open emitter) which is the same as open drain mutatis mutandis but
>> + *   pulled to ground
>
> How about "off". As I've pointed out at various times some devices have
> GPIO pins that may or may not be connected depending upon what other chip
> logic is doing.

Sure, why not.

> As I've also noted with various other previous suggestions for API
> additions you also need an "unknown" state so that a device can implement
> the methods but indicate for some pins the value is unknown due to
> hardware or firmware limitations.

OK do you want an unknown biasing mode too, or is "floating" enough
of a default to cover that?

Yours,
Linus Walleij
