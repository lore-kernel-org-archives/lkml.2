Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1DTPpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:45:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44655 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1DTPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=aD+jhBxQ62YdRhIp9CkudoapXfbS72hWn7jTppfykYGOXEEgpGCtCBQcE0hJ1nNVpv
         u3x4lkKdOaC3rqIG254dlIntoqVztCUR8MvbJdWuxpeVSUczHwOVwZp+Sx0Cg/snglwN
         e2OnlOE5eSSU/k3AFRPWgj49W9dSbjXre4mvs=
MIME-Version: 1.0
In-Reply-To: <20110420163238.5f0e5ea6@lxorguk.ukuu.org.uk>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
	<20110418132629.12d9a106@lxorguk.ukuu.org.uk>
	<6C3F739A-A157-4796-9572-C6B0FAC2565E@niasdigital.com>
	<20110419093855.36910400@lxorguk.ukuu.org.uk>
	<BANLkTimqpP2k1tBvRL0BXs9E-Q=3bh0C7Q@mail.gmail.com>
	<BANLkTint6DGgosVkjK-sveyA9SL9WVS4Mg@mail.gmail.com>
	<BANLkTinv-MSg5Sobg2X1cJpAwPkM1Gevcg@mail.gmail.com>
	<BANLkTi=Oc+y+31KugbEy66Mp96=bf_G8Mg@mail.gmail.com>
	<BANLkTinv_-6dJJXAWc=NFTceXGA9sabanA@mail.gmail.com>
	<20110420163238.5f0e5ea6@lxorguk.ukuu.org.uk>
Date: Wed, 20 Apr 2011 17:45:40 +0200
X-Google-Sender-Auth: oDUCvyuVlEV8DjIAAU2Wm3eQJdE
Message-ID: <BANLkTikWrJBDSRL-iJnqFObheeXUwJ7j_w@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Nizette <bn@niasdigital.com>, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/20 Alan Cox <alan@lxorguk.ukuu.org.uk>:

>> Even if some people are only muxing pins that can also be used as GPIO,
>> this is not always the case. We can shunt out the same pins to be used as
>> I2C or SPI for example, that means this cannot be handled in a GPIO
>> driver since it has nothing to do with GPIO pins at all.
>
> It sounds very much to me like it belongs in the GPIO driver. That is the
> one piece of code which knows what it is doing for all this configuration.

Yeah whether it goes into drivers/pinpadmux and include/linux/pinpadmux.h
or drivers/gpio and include/linux/gpio.h does not matter to me if that is it's
more natural habitat to most people :-)

Now I need to post v2 of this patchset...

Linus Walleij
