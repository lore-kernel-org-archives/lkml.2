Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2GOQC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 12:02:26 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:42878 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2GOQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 12:02:17 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 6/6] hrtimer: Update hrtimer base offsets each hrtimer_interrupt
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
	<1341960205-56738-8-git-send-email-johnstul@us.ibm.com>
	<m2y5mlnj5z.fsf__49536.0585897744$1342365803$gmane$org@igel.home>
X-Yow: Of course, you UNDERSTAND about the PLAIDS in the SPIN CYCLE --
Date: Sun, 15 Jul 2012 18:02:04 +0200
In-Reply-To: <m2y5mlnj5z.fsf__49536.0585897744$1342365803$gmane$org@igel.home>
	(Andreas Schwab's message of "Sun, 15 Jul 2012 17:22:32 +0200")
Message-ID: <m2txx9nhc3.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@linux-m68k.org> writes:

> This breaks resume on the iBook G4 (PowerBook6,7).  Apparently during or
> before noirq resume the system is hanging by the same amount of time as
> the system was sleeping.

The point where the time is wasted actually appears to be _after_ resume
(the elapsed time for the resume itself isn't affected).

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
