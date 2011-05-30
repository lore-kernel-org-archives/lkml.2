Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab1E3Ku7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:50:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59623 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab1E3Ku6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:50:58 -0400
Date: Mon, 30 May 2011 12:50:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH v2 10/10] x86-64: Document some of entry_64.S
Message-ID: <20110530105036.GG17821@elte.hu>
References: <cover.1306724657.git.luto@mit.edu>
 <dbaa4069dec9bae213e136ff6e045236b3396b87.1306724657.git.luto@mit.edu>
 <20110530075924.GE6720@liondog.tnic>
 <BANLkTi=5DK7XUwQZvC8tSM4vXu5LObBHjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=5DK7XUwQZvC8tSM4vXu5LObBHjQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Lutomirski <luto@mit.edu> wrote:

> (And whose idea was it to have pushing the error code be optional?)

I think it must have been some genius trying to save 0.1 cycles while 
spending a thousand transistors on it in the critical path and 
introducing a dozen crashes and security holes into various kernels 
;-)

Thanks,

	Ingo
