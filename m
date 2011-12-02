Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1LBI3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:29:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57438 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1LBI3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:29:15 -0500
MIME-Version: 1.0
In-Reply-To: <1322783723.21423.150.camel@work-vm>
References: <1322724016-9770-1-git-send-email-yong.zhang0@gmail.com>
	<1322724016-9770-3-git-send-email-yong.zhang0@gmail.com>
	<1322783723.21423.150.camel@work-vm>
Date: Fri, 2 Dec 2011 09:29:14 +0100
Message-ID: <CACRpkdbMvYr_ezZJ2-8qk0PVzDyPEwGJ+wCTwMnUwToEaK4v+A@mail.gmail.com>
Subject: Re: [PATCH 2/3] clocksource: dbx500: convert to clocksource_register_hz()
From: Linus Walleij <linus.walleij@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 2, 2011 at 12:55 AM, John Stultz <john.stultz@linaro.org> wrote:
> On Thu, 2011-12-01 at 15:20 +0800, Yong Zhang wrote:
>> Convert clocksource_dbx500_prcmu to use clocksource_register_hz.

> I've queued this myself, but I'd prefer it to go through the appropriate
> maintainer. That said, if I don't see it in -next in a week or so, I'll
> go ahead and add it to my 3.3 list for Thomas.

Given that the driver is in drivers/clocksource/* aren't You+Thomas
the maintainers?

Actually this is one of the instances where we try to push ARM stuff
down to a subsystem where it belongs for proper handling by the
subsystem maintainers.

This was a fortunate case since it happened to be a "clean"
clocksource driver, I don't know what to do with all the combined
clocksource+clock event drivers we have in ARM, part of me
wants to push that to drivers/clocksource too, but mainly the
cross-dependency of needing to be called during early machine
init get me to want to keep it in arch/arm/* FTM...

Yours,
Linus Walleij
