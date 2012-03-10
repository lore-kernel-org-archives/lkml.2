Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2CJWLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:11:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59651 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2CJWLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:11:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120307091816.GA28160@core.coreip.homeip.net>
References: <20120307091816.GA28160@core.coreip.homeip.net>
Date: Sat, 10 Mar 2012 23:11:17 +0100
X-Google-Sender-Auth: OSJbKWkWpLK1klXzv9KezDP6oRE
Message-ID: <CAMuHMdUyCEVr+fFmUnUABSG33juYTWdyy6-6a1uNW0+oePJR6g@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.3-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 10:18, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Dmitry Torokhov (1):
>      Input: twl4030-vibra - use proper guard for PM methods

That's commit f3761c0779b62276b5bf84532a81d5dc49bd721f?

| drivers/input/misc/twl4030-vibra.c:175:5: warning: "CONFIG_PM" is not
| defined
|
| We should use #ifdef instead of #if and also check CONFIG_PM_SLEEP
| instead of CONFIG_PM.

It still uses "#if CONFIG_PM_SLEEP", i.e. no #ifdef.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
