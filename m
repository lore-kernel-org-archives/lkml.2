Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2HEKGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 06:06:06 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35943 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2HEKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 06:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120801152240.GA16388@sig21.net>
References: <20120801152240.GA16388@sig21.net>
Date: Sun, 5 Aug 2012 12:06:03 +0200
Message-ID: <CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com>
Subject: Re: DT GPIO numbering?
From: Linus Walleij <linus.walleij@linaro.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 1, 2012 at 5:22 PM, Johannes Stezenbach <js@sig21.net> wrote:

> I'm currently learning how Linux devicetree support works,
> here is one question I couldn't find an answer for.
>
> I understand that within the devicetree GPIOs are referenced by phandle,
> thus the numbers are irrelevant.  However, in sysfs the number is
> what is used to access the GPIO, e.g. for debugging or
> blinkenlight apps.  How does this fit together?

I think it simply does not fit together.

Grant & me has been claiming the GPIO sysfs interface is a bit
crazy from time to time.

My long-term plan would be to replace it with /dev/gpio/gpioN
device nodes per-gpiochip and use ioctl etc to control these
beasts instead. However one does not do that overnight,
and my life is too busy, and other refactorings also need to
happen :-/

Yours,
Linus Walleij
