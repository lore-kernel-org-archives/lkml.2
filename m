Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2LTKk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:40:29 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:48707 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LTKkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:40:22 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 05:40:21 EST
MIME-Version: 1.0
In-Reply-To: <50D2E8BB.6000108@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
	<1352720953-24321-15-git-send-email-vgupta@synopsys.com>
	<201211121400.13046.arnd@arndb.de>
	<50D2B75A.3000208@synopsys.com>
	<50D2E8BB.6000108@synopsys.com>
Date: Thu, 20 Dec 2012 11:34:58 +0100
X-Google-Sender-Auth: S0Udctjg6KRPY90z-yjWCENd_rE
Message-ID: <CAMuHMdWJF4rJ=CZ1wtLvbNKF8Pv-NvSie4zx+V2OC64pxHpBQQ@mail.gmail.com>
Subject: Re: [RFC Patch v1 45/55] ARC: unaligned access emulation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 11:30 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> Sorry for a naive patch submitter question (yes I've already read
> SubmittingPatches and googled much already). A lot of times, I see the
> "Cc: ..." lines, just below the "Signed-off-by:" lines in the patch -
> e.g. https://lkml.org/lkml/2012/10/4/318
> Are those added manually - because none of the xxx-cc options to
> format-patch or send-email seem to be doing that - unless I missed some.
>
> Context: I have the patch which touches ia64/parisc which I want to send
> out and at the same time have those "Cc: lines for the maintainers too"

I add them manually, either while committing, or by editing the patch after
running "git format-patch".

"git send-email" will pick them up and add the appropriate CCs when sending
out the emails.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
