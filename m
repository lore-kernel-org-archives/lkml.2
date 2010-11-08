Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0KHSPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:15:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab0KHSPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:15:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, stable@kernel.org
Subject: Re: [PATCH] posix-cpu-timers: workaround to suppress the problems with
	mt exec
In-Reply-To: Oleg Nesterov's message of  Friday, 5 November 2010 16:53:42 +0100 <20101105155342.GA13606@redhat.com>
References: <20101102135821.GA5964@swordfish.minsk.epam.com>
	<alpine.LFD.2.00.1011021630150.9357@localhost6.localdomain6>
	<20101102160223.GC5964@swordfish.minsk.epam.com>
	<alpine.LFD.2.00.1011021704110.9357@localhost6.localdomain6>
	<20101102183308.GA17720@redhat.com>
	<20101103105832.GA30053@swordfish.minsk.epam.com>
	<20101103124835.GA604@redhat.com>
	<20101103161059.GA13530@redhat.com>
	<20101105155342.GA13606@redhat.com>
X-Shopping-List: (1) Lustrous bird cheater-hawks
   (2) Consistent recreational will-o'-the-wisps
   (3) Analytical ingenuous lesions
Message-Id: <20101108181419.60EC6400DB@magilla.sf.frob.com>
Date: Mon,  8 Nov 2010 10:14:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That seems like a reasonable workaround off hand.  But since all the
reworkings I am no longer particularly authoritative on this code.


Thanks,
Roland

