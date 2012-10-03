Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab2JCXLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:11:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41660 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab2JCXLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <50686955.8040503@antcom.de>
References: <1348780923-27428-1-git-send-email-stigge@antcom.de>
	<CAOY=C6GG6jqqEAAGJjmDG-BFT2eq=9+ck+F_EOcthRgDCDv8=Q@mail.gmail.com>
	<50682402.8020402@antcom.de>
	<CAOY=C6FaLckRHSfAHvw2=J9xZEVFDZPL+1oKnKeGnpOGPFVB1w@mail.gmail.com>
	<506860C6.5020408@antcom.de>
	<CAOY=C6F1rHoGM0T9FqLYuVwzaidDZBzEf_uWn9mP8fmT1oURTQ@mail.gmail.com>
	<50686955.8040503@antcom.de>
Date: Thu, 4 Oct 2012 01:11:06 +0200
Message-ID: <CACRpkdbVLq3WsKZJ=K+CtuSNfZeDkCYhKwDmEwL4s2TC06WN-Q@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] gpio: Add a block GPIO API to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Stijn Devriendt <highguy@gmail.com>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        bgat@billgatliff.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 5:46 PM, Roland Stigge <stigge@antcom.de> wrote:
> On 30/09/12 17:19, Stijn Devriendt wrote:
>>
>> Rules are rules, but why make the interface overly complex when
>> the multi-value file is saner, cleaner and simpler?
>
> Simply because they won't (and probably shouldn't) accept it mainline.

We, including you and Stijn *are* the mainline ... ;-)

The only reason I really dislike it is that the GPIO sysfs interface is
scary as it is, so I don't want to add to it if we can instead push to
reform it into something more sane.

Linus Walleij
