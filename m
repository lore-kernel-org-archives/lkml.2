Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2DSXP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab2DSXPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:15:25 -0400
Date: Fri, 20 Apr 2012 01:14:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <agordeev@redhat.com>, Chris Zankel <chris@zankel.net>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Kuo <rkuo@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/6] task_work_add: generic process-context callbacks
Message-ID: <20120419231431.GA15820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The final-final-final version. Andrew, I hope you can take it.

Compared to v5 this series has the new patches which remove the
dead code, 5/6 and 6/6.

And, while doing 5/6 I noticed that arch/hexagon/kernel/signal.c
lacks tracehook_notify_resume(), this one-liner comes as 3/6.

The patches from v5 were not changed.

To all: sorry for this endless spam. It seems that nobody objects,
I'll trim CC if I need to send v7.

Oleg.

