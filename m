Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab0HUJOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:14:39 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51553 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab0HUJOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iPogEuhd7XY7t2PYeCQG94MEA2QXWgVl7NWbe+puvZoiuDS1Y9exvhWDk0M5m9ZCbW
         uKrXjrqPTqJxPwpVGn2jm/DX/icvUOSOJI9XT7T1e5IoPI37V7+mdxlpZ3CQS58hJl7X
         Hrq/BS8LUHa28H8kvqxlOgnCix9HefNCd2KX0=
MIME-Version: 1.0
In-Reply-To: <20100820215206.GI3650@sortiz-mobl>
References: <1282037077-29255-1-git-send-email-mattias.wallin@stericsson.com>
	<20100820215206.GI3650@sortiz-mobl>
Date: Sat, 21 Aug 2010 11:14:35 +0200
Message-ID: <AANLkTinzwQpi=z8-r6sM=aCdRoqBqnpYABFowAid1b=+@mail.gmail.com>
Subject: Re: [PATCH 1/2] MFD: Align ab8500 with the abx500 interface
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/20 Samuel Ortiz <sameo@linux.intel.com>:
> On Tue, Aug 17, 2010 at 11:24:37AM +0200, Mattias Wallin wrote:

>> This patch makes the ab8500 mixed signal chip expose the same
>> interface for register access as the ab3100, ab3550 and ab5500 chip.
>> The ab8500_read() and ab8500_write() is removed and replaced with
>> abx500_get_register_interruptible() and
>> abx500_set_register_interruptible().

> Thanks for the patch, but I'd prefer to see it split into 3 separate ones, for
> mfd, rtc and regulator. And then have the relevant maintaines cc'ed with those
> patches.

... but that will have the side effect of making it non-bisectable will
it not? If we change the interface of AB8500 to abx500.h in one
patch that breaks the users and the order is not restored until all
patches are applied.

Isn't it better to just resend the same patch and Cc: the relevant
subsystem maintainers on it?

I'll sign it off and do this, I should've been in the submit path
anyway.

If you prefer to have it non-bisectable I'll post yet another version
for that.

Yours,
Linus Walleij
