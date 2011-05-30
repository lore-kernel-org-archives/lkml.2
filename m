Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1E3Hq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:46:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60989 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829Ab1E3Hq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:46:27 -0400
Date: Mon, 30 May 2011 09:46:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH v2 08/10] x86-64: Emulate vsyscalls
Message-ID: <20110530074608.GD27557@elte.hu>
References: <cover.1306724657.git.luto@mit.edu>
 <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
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


* Andy Lutomirski <luto@MIT.EDU> wrote:

> There's a fair amount of code in the vsyscall page, and who knows
> what will happen if an exploit jumps into the middle of it.  Reduce
> the risk by replacing most of it with short magic incantations that
> are useless if entered in the middle.  This change can be disabled
> by CONFIG_UNSAFE_VSYSCALLS (default y).

btw., please flip the default or consider removing the option 
altogether.

We want to improve security and we want safe vsyscalls the default, 
and it's no good if we make it too easy for users to keep the fire 
door open all the time! :-)

Thanks,

	Ingo
