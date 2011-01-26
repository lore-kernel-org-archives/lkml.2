Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab1AZGUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 01:20:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1AZGU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 01:20:27 -0500
Date: Wed, 26 Jan 2011 07:19:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Alessio Igor Bogani <abogani@texware.it>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jan Blunck <jblunck@infradead.org>,
        John Kacur <jkacur@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.org>,
        Paul Menage <menage@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 20/20] BKL: That's all, folks
Message-ID: <20110126061954.GA32096@elte.hu>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
 <1295993854-4971-21-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295993854-4971-21-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnd Bergmann <arnd@arndb.de> wrote:

> This removes the implementation of the big kernel lock,
> at last. A lot of people have worked on this in the
> past, I so the credit for this patch should be with
> everyone who participated in the hunt.
> 
> The names on the Cc list are the people that were the
> most active in this, according to the recorded git
> history, in alphabetical order.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Alessio Igor Bogani <abogani@texware.it>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Jan Blunck <jblunck@infradead.org>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: Paul Menage <menage@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> ---
>  include/linux/hardirq.h  |    9 +---
>  include/linux/smp_lock.h |   65 ----------------------
>  init/Kconfig             |    5 --
>  kernel/sched.c           |    7 ---
>  lib/Makefile             |    1 -
>  lib/kernel_lock.c        |  136 ----------------------------------------------
>  6 files changed, 1 insertions(+), 222 deletions(-)
>  delete mode 100644 include/linux/smp_lock.h
>  delete mode 100644 lib/kernel_lock.c

Yay!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
