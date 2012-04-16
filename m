Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2DPWBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:01:36 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60551 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2DPWBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:30 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>
	<20120411070332.6F3C03E081E@localhost> <m21unuoch5.fsf@igel.home>
	<CACxGe6sDcqu6TcS9ZYYeNffMdUrH0_SVou37H83qzM8mKAGV_A@mail.gmail.com>
X-Yow: I don't know WHY I said that..  I think it came from the FILLINGS
 in my rear molars..
Date: Tue, 17 Apr 2012 00:01:26 +0200
In-Reply-To: <CACxGe6sDcqu6TcS9ZYYeNffMdUrH0_SVou37H83qzM8mKAGV_A@mail.gmail.com>
	(Grant Likely's message of "Wed, 11 Apr 2012 08:52:03 -0600")
Message-ID: <m2bomrz689.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

> Also, gcc complains about it:
>
> /home/grant/hacking/linux/kernel/irq/irqdomain.c: In function ‘virq_debug_show’:
> /home/grant/hacking/linux/kernel/irq/irqdomain.c:670:4: warning: '#'
> flag used with ‘%p’ gnu_printf format [-Wformat]

Then it's probably not such a good idea after all.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
