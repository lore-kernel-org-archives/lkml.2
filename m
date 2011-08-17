Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1HQJhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 05:37:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45366 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1HQJhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 05:37:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110817090123.GD1006@n2100.arm.linux.org.uk>
References: <1312978564-18069-1-git-send-email-linus.walleij@stericsson.com>
	<20110817090123.GD1006@n2100.arm.linux.org.uk>
Date: Wed, 17 Aug 2011 11:37:01 +0200
Message-ID: <CACRpkdbJOrb5rhgG0Chamt-ApLQnV69MQ=bqBwKqO3KJPaFd0A@mail.gmail.com>
Subject: Re: [PATCH 00/19] GPIO exodus and cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 11:01 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Aug 10, 2011 at 02:16:04PM +0200, Linus Walleij wrote:
>> The following patch set is rebased on top of Russell's
>> 13 cleanup patches and can be finalized as soon as there
>> is a branch in RMKs tree that can accumulate this work.
>
> If Grant acks the relevant ones, they can go to the patch system and
> merged into that branch.

Thanks that'd be smooth.

Grant can you N/ACK the patches you consider relevant for
the GPIO subsystem?

I'll send out a new patch set since I've included a patch from
Hartley fixing up the ep93xx gpiolib to be self-contained.

Thanks,
Linus Walleij
