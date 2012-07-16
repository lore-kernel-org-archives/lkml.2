Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2GPW2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:28:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57670 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab2GPW2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:28:15 -0400
MIME-Version: 1.0
In-Reply-To: <1342225001-22962-3-git-send-email-mturquette@linaro.org>
References: <1342225001-22962-1-git-send-email-mturquette@linaro.org>
	<1342225001-22962-3-git-send-email-mturquette@linaro.org>
Date: Tue, 17 Jul 2012 00:28:14 +0200
Message-ID: <CACRpkda7g2qMErwf-nebKSOW=044=YadEzEoKWM1dT=29yueeA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RFC] cpufreq: omap: scale regulator from clk notifier
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Turquette <mturquette@linaro.org>, "Nori, Sekhar" <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        rob.herring@calxeda.com, pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        viresh.kumar@linaro.org, rnayak@ti.com, paul@pwsan.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        ccross@android.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 2:16 AM, Mike Turquette <mturquette@linaro.org> wrote:
'
> This patch moves direct control of the MPU voltage regulator out of the
> cpufreq driver .target callback and instead puts that logic into a clock
> rate change notifier callback.

That's heavy stuff.

I was hoping that the first example of using clk notifiers would be
something like mach-davinci replacing it's legacy clock framework
with drivers/clk and then go in and change the horrid cpufreq hack
that is currently in drivers/mmc/host/davinci_mmc.c to use a
clock notifier instead of cpufreq.

Sekhar/Kevin, any chance to have DaVinci converted to Mikes new
clock framework? It doesn't look super-complex and would be a
good example for others I think.

Yours,
Linus Walleij
