Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1CFTCp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 14:02:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40881 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1CFTCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 14:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
	<AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
	<4D714C17.7080102@gmail.com>
	<AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com>
	<eea425c066cc69c30f118fb102fff43e@mail.gmail.com>
	<AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com>
	<7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com>
	<AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com>
Date: Sun, 6 Mar 2011 20:02:42 +0100
Message-ID: <AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency withcpufreqnotifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Colin Cross <ccross@android.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        martin persson <martin.persson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 6, 2011 at 6:42 PM, Colin Cross <ccross@android.com> wrote:

> Is there any way
> for a clockevent to invalidate the current event and ask for it to be
> reprogrammed?

TGLX will know for sure... Thomas?

(This is inside a CPUfreq hook for a localtimer for the record.)

Yours,
Linus Walleij
