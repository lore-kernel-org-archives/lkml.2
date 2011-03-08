Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1CHNel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:34:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55950 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1CHNek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:34:40 -0500
MIME-Version: 1.0
In-Reply-To: <20110308132912.GC5892@sirena.org.uk>
References: <1299577320-31389-1-git-send-email-linus.walleij@stericsson.com>
	<20110308115640.GC20944@opensource.wolfsonmicro.com>
	<AANLkTin7qD7O70u5HQVgWXQZTFR1O8dUOqyKWmn6sU1b@mail.gmail.com>
	<20110308132912.GC5892@sirena.org.uk>
Date: Tue, 8 Mar 2011 14:34:38 +0100
Message-ID: <AANLkTi=oP8dgGVZVT4FbfHjrN6vjFhDmTwJrKacv_94-@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: add a subdriver for TI TPS6105x regulator portions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 8, 2011 at 2:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

>> So the fact that the regulator driver doesn't probe doesn't mean any
>> failure, some other driver will likely probe successfully for the chip.
>
> The general approach other MFDs have taken to this is to pay attention
> to the platform data when registering subdevices so that you don't get
> inappropriate subdevices registered in the first place.

Ah, clever. I'll fix.

Yours,
Linus Walleij
