Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab2FHI5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:57:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34664 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934020Ab2FHI5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:57:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120607215305.GA19760@sirena.org.uk>
References: <1338916327-3958-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<CACRpkdY379kHbaMhGD4Q9y=Nkv2NPey+n1zUuTLAE-j7f8gadA@mail.gmail.com>
	<20120607215305.GA19760@sirena.org.uk>
Date: Fri, 8 Jun 2012 10:57:47 +0200
Message-ID: <CACRpkdYm3sE9CuFh20CWfFg1dj-i+rfPW5gVQLY2cJdQs_2Erg@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: wm8994: Pay attention to the value set when
 enabling as output
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 11:53 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

>> Could you elaborate on the problem ans symptoms, just for a nice
>> commit log?
>
> I'm not really sure what more there is to say...

But you do ;-)

> previously we were
> ignoring the value that's set as part of setting output mode so if
> someone wanted to set a value different to the one the chip happened to
> have that wouldn't happen.  Ignoring the vaue that the user is trying to
> set seems like an obvious enough bug in itself.

Throw that into the commit message and I'm in for it!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
