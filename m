Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1EaNqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:46:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54342 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab1EaNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:46:15 -0400
Date: Tue, 31 May 2011 15:45:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 00/10] Remove syscall instructions at fixed addresses
Message-ID: <20110531134549.GA15598@elte.hu>
References: <cover.1306847455.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1306847455.git.luto@mit.edu>
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


* Andy Lutomirski <luto@mit.edu> wrote:

> Patch 1 is just a bugfix from the last vdso series.
> The bug should be harmless but it's pretty dumb.  This is almost
> certainly 3.0 material.

Please make the patches apply cleanly to the latest x86 tree:

  http://people.redhat.com/mingo/tip.git/README

they currently don't - patch #4 does not apply.

Thanks,

	Ingo
