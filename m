Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1E3IHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 04:07:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48720 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1E3IHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 04:07:31 -0400
Date: Mon, 30 May 2011 10:07:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: Andy Lutomirski <luto@MIT.EDU>, Borislav Petkov <bp@alien8.de>,
        Jesper Juhl <jj@chaosbits.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mikael Pettersson <mikpe@it.uu.se>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/10] x86-64: Emulate vsyscalls
Message-ID: <20110530080712.GH27557@elte.hu>
References: <cover.1306724657.git.luto@mit.edu>
 <cover.1306724657.git.luto@mit.edu>
 <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
 <4DE3688D020000780004427E@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE3688D020000780004427E@vpn.id2.novell.com>
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


* Jan Beulich <JBeulich@novell.com> wrote:

> >>> On 30.05.11 at 05:48, Andy Lutomirski <luto@MIT.EDU> wrote:
> > This causes vsyscalls to be a little more expensive than real
> > syscalls.  Fortunately sensible programs don't use them.
> 
> Hmm - weren't vsyscalls there for performance reasons?

New code uses the vDSO. The fixed-address vsyscalls are apparently 
only used in esoteric cases like statically linked glibc binaries. 
(which should arguably be using the vDSO as well)

Thanks,

	Ingo
