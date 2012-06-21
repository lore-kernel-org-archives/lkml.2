Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2FUHhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:37:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50006 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2FUHhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <4FE1C952.5000306@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-9-git-send-email-lee.jones@linaro.org>
	<20120614183231.GA30185@sirena.org.uk>
	<4FDEEEBD.5070108@linaro.org>
	<20120618102003.GB12029@n2100.arm.linux.org.uk>
	<20120618185638.GY3974@opensource.wolfsonmicro.com>
	<4FE1C952.5000306@linaro.org>
Date: Thu, 21 Jun 2012 09:37:44 +0200
Message-ID: <CACRpkdYszGAixL_2CiPLRJ2Pasq_GwxnR1np+y83miOXhanNQg@mail.gmail.com>
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 3:00 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On 18/06/12 19:56, Mark Brown wrote:
>>
>> Yes, that's correct.  I'm surprised the code runs without crashing...
>
> Oddly the code ran perfectly.

So how did you test it?

The only way to generate an IRQ on the AB8500 with the mainline code is
to push the power button, that should generate an event from the
driver in drivers/input/misc/ab8500-ponkey.c that you can listen to
by doing cat on the proper /dev/input/eventN file.

Please test this scenario before and after the patch and you have some
indication that the IRQdomain is working.

Yours,
Linus Walleij
