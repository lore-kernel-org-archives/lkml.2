Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2GOPXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 11:23:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49179 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab2GOPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 11:22:38 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 6/6] hrtimer: Update hrtimer base offsets each hrtimer_interrupt
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
	<1341960205-56738-8-git-send-email-johnstul@us.ibm.com>
X-Yow: Awright, which one of you hid my PENIS ENVY?
Date: Sun, 15 Jul 2012 17:22:32 +0200
In-Reply-To: <1341960205-56738-8-git-send-email-johnstul@us.ibm.com> (John
	Stultz's message of "Tue, 10 Jul 2012 18:43:25 -0400")
Message-ID: <m2y5mlnj5z.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This breaks resume on the iBook G4 (PowerBook6,7).  Apparently during or
before noirq resume the system is hanging by the same amount of time as
the system was sleeping.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
