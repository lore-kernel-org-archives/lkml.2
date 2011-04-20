Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1DTO0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 10:26:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36680 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab1DTO0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 10:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ScFoeGpNQwJR/FFL+kBIrcrAC8H2h1aPFOH9CTp2gIsdsCTXMnhERuX9/mgMehhRv7
         BzBgdKhNI+r28qThdW0UkY1EiAV/oEdk24uLn8sdfC5EbeETZB1rxoowCE44IUZ2EKXS
         oTN5AeoJdnccfcQljepLpmp8+4VEBV9DgPCVE=
MIME-Version: 1.0
In-Reply-To: <BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
Date: Wed, 20 Apr 2011 22:26:14 +0800
Message-ID: <BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ben Nizette <bn@niasdigital.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 4:51 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>>
>> Leaving aside the current input/output and on/off bits I would go for
>> being able to do
>>
>>        gpio_get_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER);
>>        gpio_set_property(gpio, GPIO_BIAS, GPIO_BIAS_WHATEVER_ELSE);
>
> One more consideration, not mentioned previous time, is that pin
> configuration for power down mode.
> Samsung SoCs has retention GPIO configurations at sleep (suspend)
> mode. and restore it at resume time.
> it's need to reduce power and proper operation after suspend.
>
I have a little confusion. In ARM SoC, a lot of pins are used as
multi-functions.

Before suspend, it may be configured as some function that isn't GPIO.
Is it a goal
that avoid declaring gpio_request() for suspend and updating the setting of pin?

Linus,
Are these two patches are post in mailing list? I can't find your
second patch in this
patch series?
