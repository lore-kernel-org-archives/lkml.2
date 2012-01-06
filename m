Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab2AFRth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:49:37 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:46397 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab2AFRtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:49:35 -0500
X-Auth-Info: uNstQocJMaCy+yYuVD33GA9150Myk6m71VZ6Znk9xms=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler changes for v3.3
References: <20120105140846.GA32342@elte.hu>
	<CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
X-Yow: Well, I'm INVISIBLE AGAIN..  I might as well pay a visit to the
 LADIES ROOM...
Date: Fri, 06 Jan 2012 18:49:29 +0100
In-Reply-To: <CA+55aFwNzNSd2B57XYLC5r9sg=+GD=dP-UPZQDxmLXyLODS6+w@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 6 Jan 2012 08:58:55 -0800")
Message-ID: <m2boqg4t7a.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> And by "clashes badly", I mean it. The sparse cleanups added a lot of
> casts between the types, which means that the mindless
>
>     +#define usecs_to_cputime64(us)         usecs_to_cputime(us)
>
> introduced by that commit 34845636a184 is now likely *wrong*, because
> "usecs_to_cputime()" now explicitly casts to a non-64-bit cputime_t.

Both s390 and powerpc define cputime_t and cputime64_t as the same
types, so this is ok.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
