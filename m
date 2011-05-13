Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab1EMVPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:15:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46659 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab1EMVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:15:43 -0400
Date: Fri, 13 May 2011 22:15:12 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Colin Cross <ccross@android.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        martin persson <martin.persson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Jonas =?iso-8859-1?Q?=C5berg?= <jonas.aberg@stericsson.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency
	withcpufreqnotifiers
Message-ID: <20110513211512.GA30539@n2100.arm.linux.org.uk>
References: <4D714C17.7080102@gmail.com> <AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com> <eea425c066cc69c30f118fb102fff43e@mail.gmail.com> <AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com> <7e9fafa016bfe536ccc373fc2cc7ba61@mail.gmail.com> <AANLkTinRNG4nTjh15a2tuJt_iDboHUtomxemSjY+6DcD@mail.gmail.com> <AANLkTikkcYw66MiJO9Bpm+De=XD2-1MFxm-CUPp6sMqL@mail.gmail.com> <BANLkTi=-T6P0KrsQ8+Ot_inq1JabY62LvA@mail.gmail.com> <alpine.LFD.2.02.1105131138460.2831@ionos> <BANLkTikY9VBXuT78k3GFkeG+q=ppMsz3iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikY9VBXuT78k3GFkeG+q=ppMsz3iQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 12:59:20PM +0200, Linus Walleij wrote:
> This patch is interesting because it uses calc_mult_shift() and the current
> localtimer driver for TWD (arch/arm/kernel/smp_twd.c) still uses hardcoded
> mult+shift.

I don't think there's any reason it uses a hard coded shift, just
that's what was the norm when the code was originally written.  It
(and many other clock event code) probably could do with an update.
