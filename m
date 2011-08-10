Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1HJNGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:06:50 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43000 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HJNGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110704153039.GM3021@sortiz-mobl>
References: <1309252083-26836-1-git-send-email-linus.walleij@stericsson.com>
	<20110704153039.GM3021@sortiz-mobl>
Date: Wed, 10 Aug 2011 15:06:48 +0200
Message-ID: <CACRpkdbDrSfgjZA+4Xs4qcYW23rhFikMWtRinmp_Fg4bQmv1+w@mail.gmail.com>
Subject: Re: [PATCH] mfd/ab8500-gpadc: refactor GPADC API, add raw access
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kalle Komierowski <kalle.komierowski@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 4, 2011 at 5:30 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Tue, Jun 28, 2011 at 11:08:03AM +0200, Linus Walleij wrote:
>> From: Kalle Komierowski <kalle.komierowski@gmail.com>
>>
>> - A bug in the use of the exported functions made the raw ADC
>>   value converted to voltage entity twice.
>
> Please separate this one from the API renaming/clarification.

Sorry that line is just a clarification for the patch itself. The
signature of the functions made that bug occur in consumers
calling the GPADC functions, due to the fact that they
though massaged values were raw.

So by doing this API change the mistake is not that easy
to make again.

I'll reword and repost the patch.

Thanks,
Linus Walleij
