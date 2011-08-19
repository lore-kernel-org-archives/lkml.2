Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1HSMpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:45:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62323 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1HSMpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbJOrb5rhgG0Chamt-ApLQnV69MQ=bqBwKqO3KJPaFd0A@mail.gmail.com>
References: <1312978564-18069-1-git-send-email-linus.walleij@stericsson.com>
	<20110817090123.GD1006@n2100.arm.linux.org.uk>
	<CACRpkdbJOrb5rhgG0Chamt-ApLQnV69MQ=bqBwKqO3KJPaFd0A@mail.gmail.com>
Date: Fri, 19 Aug 2011 14:45:19 +0200
Message-ID: <CACRpkdYw96QD0sGOhA=osKYbnD6=MTqiAF=m5++BjM-s1Mn--w@mail.gmail.com>
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

On Wed, Aug 17, 2011 at 11:37 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Wed, Aug 17, 2011 at 11:01 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Wed, Aug 10, 2011 at 02:16:04PM +0200, Linus Walleij wrote:
>>> The following patch set is rebased on top of Russell's
>>> 13 cleanup patches and can be finalized as soon as there
>>> is a branch in RMKs tree that can accumulate this work.
>>
>> If Grant acks the relevant ones, they can go to the patch system and
>> merged into that branch.
>
> Thanks that'd be smooth.
>
> Grant can you N/ACK the patches you consider relevant for
> the GPIO subsystem?

Ping on this, on monday I'll pretend it's no big deal and pour them
into Russells patch tracker anyway, since he's managing more than
half of the kernels GPIO code in arch/arm/* anyway.

Thanks,
Linus Walleij
