Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab1FMInb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:43:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36103 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1FMIna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B879F@AUSP01VMBX24.collaborationhost.net>
References: <1307695752-28051-1-git-send-email-linus.walleij@stericsson.com>
	<ADE657CA350FB648AAC2C43247A983F001F3820B879F@AUSP01VMBX24.collaborationhost.net>
Date: Mon, 13 Jun 2011 10:43:29 +0200
Message-ID: <BANLkTinMPXQcS2tZAJE57d=J4XbpGp_aFg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: expose gpio_to_chip()
From: Linus Walleij <linus.walleij@linaro.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 5:57 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Friday, June 10, 2011 1:49 AM, Linus Walleij wrote:

>> This makes the gpio_to_chip() function available to drivers. The
>> usecase is when you want to add a few chip-specific operations
>> apart from the ones exposed in struct gpio_chip.
> (...)
>
> Linus,
>
> You'll need to fix a couple drivers for this to work.  The symbol gpio_to_chip
> is a static symbol in a couple places other than gpiolib.c.

OK I fix! They are confusing anyway so should be patched pronto.

Linus Walleij
