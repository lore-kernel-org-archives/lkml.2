Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab1ETVu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 17:50:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37027 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab1ETVur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 17:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <1305851091-10096-1-git-send-email-ccross@android.com>
References: <1305851091-10096-1-git-send-email-ccross@android.com>
Date: Fri, 20 May 2011 23:50:45 +0200
Message-ID: <BANLkTikzhC68w1AD59Vqw2vopDwu=YjOEQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: smp_twd: Reconfigure clockevents after cpufreq change
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 2:24 AM, Colin Cross <ccross@android.com> wrote:

> The localtimer's clock changes with the cpu clock.  After a
> cpufreq transition, update the clockevent's frequency and
> reprogram the next clock event.
>
> Adds a clock called "smp_twd" that is used to determine the
> twd frequency, which can also be used at init time to
> avoid calibrating the twd frequency.
>
> Clock changes are based on Rob Herring's work.
>
> Change-Id: I413b5cd07fb2b79bc9fad8b4bf257332d1da7bcd
> Signed-off-by: Colin Cross <ccross@android.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rob Herring <robherring2@gmail.com>
> Tested-by: Linus Walleij <linus.walleij@linaro.org>

OK Thomas can you take this in through the clock/timer
branch? Works fine for me and Colin and solves many problems
apart from making the code look neat.

Yours,
Linus Walleij
