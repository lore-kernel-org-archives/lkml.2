Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1AZLCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:02:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1AZLC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:02:28 -0500
Date: Wed, 26 Jan 2011 12:01:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
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
Message-ID: <20110126110159.GB27809@elte.hu>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
 <1295993854-4971-21-git-send-email-arnd@arndb.de>
 <20110126061954.GA32096@elte.hu>
 <20110126084701.589322a2@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126084701.589322a2@bob.linux.org.uk>
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


* Alan Cox <alan@linux.intel.com> wrote:

> > Yay!
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> Acked-by: Alan Cox <alan@linux.intel.com>
> 
> Nice to see it gone - it seemed such a good idea in Linux 1.3

No need to feel bad about it - there was simply no other way to do it: the BKL 
basically represented all the single-CPU assumptions that were built into the kernel 
from 0.10 up to 1.3 (and at least as much new BKL depending code going forward as 
well ...).

Every last such piece of code had to be eliminated. So the BKL represented the 
status quo - and eliminating the status quo is always hard, as the code that remains 
became less and less important :-)

Thanks,

	Ingo
