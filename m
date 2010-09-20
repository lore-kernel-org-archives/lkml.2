Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab0ITL6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 07:58:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0ITL6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 07:58:49 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Andy Clark <andy.apcs@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [x86] x86 targets without CMOS still build rtc.c despite CONFIG_RTC unset
References: <AANLkTimigBxKWaJ6LNxu6a0uXo8+LOfzcoE8bVsXZ1bW@mail.gmail.com>
X-Yow: This PORCUPINE knows his ZIPCODE..  And he has ``VISA''!!
Date: Mon, 20 Sep 2010 13:58:45 +0200
In-Reply-To: <AANLkTimigBxKWaJ6LNxu6a0uXo8+LOfzcoE8bVsXZ1bW@mail.gmail.com>
	(Andy Clark's message of "Mon, 20 Sep 2010 12:49:38 +0100")
Message-ID: <m3fwx48w3u.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Clark <andy.apcs@googlemail.com> writes:

> I haven't taken the time to fully understand the build mechanism, but
> comparing the x86 with other targets, the x86 target doesn't appear to
> support CONFIG_RTC.  Leaving this unset doesn't prevent
> arch/x86/kernel/rtc.c being built into the kernel.

CONFIG_RTC is unrelated to arch/x86/kernel/rtc.c.  It controls
drivers/char/rtc.c.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
