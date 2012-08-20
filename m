Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2HTUFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:05:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:49173 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2HTUFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:05:02 -0400
X-Auth-Info: EhMjSMYTNy2KShdJI49PkZIaIALOR4pra1wQ6Oo8HDI=
From: Andreas Schwab <schwab@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 4/8] time: Condense timekeeper.xtime into xtime_sec
References: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
	<1342156917-25092-5-git-send-email-john.stultz@linaro.org>
	<m2fw7ilhnm.fsf@igel.home> <503288ED.10306@linaro.org>
	<m2fw7h4ab5.fsf@igel.home> <503296C1.4070906@linaro.org>
X-Yow: First, I'm going to give you all the ANSWERS to today's test..
 So just plug in your SONY WALKMANS and relax!!
Date: Mon, 20 Aug 2012 22:04:58 +0200
In-Reply-To: <503296C1.4070906@linaro.org> (John Stultz's message of "Mon, 20
	Aug 2012 12:57:53 -0700")
Message-ID: <m2boi549ed.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:

> Huh.  Yea, that looks fine.  And without the
> __timekeeping_inject_sleeptime() call, the system resumed ok?

Yes, it does.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
