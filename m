Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2GPMtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:49:06 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49459 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2GPMtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:49:02 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org
Subject: Re: [Regression][Revert request] Excessive delay or hang during resume from system suspend due to a hrtimer commit
References: <201207152240.50129.rjw@sisk.pl>
	<alpine.LFD.2.02.1207161035500.32033@ionos>
	<201207161316.28875.rjw@sisk.pl>
X-Yow: Could I have a drug overdose?
Date: Mon, 16 Jul 2012 14:48:55 +0200
In-Reply-To: <201207161316.28875.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 16 Jul 2012 13:16:28 +0200")
Message-ID: <m2ehobzxag.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday, July 16, 2012, Thomas Gleixner wrote:
>> Does the following patch fix the problem for you ?
>
> Yes, it does, thanks!

Works for me as well.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
