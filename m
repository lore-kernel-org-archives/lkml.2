Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1FSLTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:19:10 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35677 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab1FSLTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:19:09 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitzmic@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "Linux\/m68k" <linux-m68k@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com>
	<m2sjr8gyp0.fsf@igel.home>
	<BANLkTikxzQSXLfr81q+b1rScW8YCcoJZRQ@mail.gmail.com>
X-Yow: How many retired bricklayers from FLORIDA are out purchasing
 PENCIL SHARPENERS right NOW??
Date: Sun, 19 Jun 2011 13:19:05 +0200
In-Reply-To: <BANLkTikxzQSXLfr81q+b1rScW8YCcoJZRQ@mail.gmail.com> (Geert
	Uytterhoeven's message of "Sun, 19 Jun 2011 12:17:34 +0200")
Message-ID: <m2mxhejcgm.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> BUG_ON(!irqs_disabled()) triggers as flags is 0x2619 there.

Which is correct, since arch_local_irq_disable would set it to 2719.
You need to find out why arch_local_irq_disable wasn't called.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
