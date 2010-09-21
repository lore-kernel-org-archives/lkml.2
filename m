Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0IUWxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:53:17 -0400
Received: from 110-197-170-69.skybeam.com ([69.170.197.110]:56371 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752517Ab0IUWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:53:16 -0400
X-Greylist: delayed 2958 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Sep 2010 18:53:16 EDT
From: Jake Edge <jake@lwn.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] sched: START_NICE feature (temporarily niced forks) (v4)
References: <20100920191929.GA29026@Krystal>
Date: Tue, 21 Sep 2010 16:01:57 -0600
In-Reply-To: <20100920191929.GA29026@Krystal> (Mathieu Desnoyers's message of
	"Mon, 20 Sep 2010 15:19:30 -0400")
Message-ID: <m34odibvsa.fsf@lwn.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

> +	u64			fork_nice_timeout;
> +	unsigned int		fork_nice_penality;

A pedantic nit from an editor-type: penalty doesn't have an 'i', so you
probably want 'fork_nice_penalty'.

jake

-- 
Jake Edge - jake@lwn.net - http://www.lwn.net
