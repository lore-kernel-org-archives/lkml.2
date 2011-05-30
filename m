Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab1E3ONH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 10:13:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1E3ONG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 10:13:06 -0400
Date: Mon, 30 May 2011 16:12:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
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
Message-ID: <20110530141246.GB12360@elte.hu>
References: <cover.1306724657.git.luto@mit.edu>
 <07445623494a3d9f02581eb06326420f5f443043.1306724657.git.luto@mit.edu>
 <20110530074608.GD27557@elte.hu>
 <BANLkTi=aX5un5ZPVD9u6NRJb-koFG7T=6w@mail.gmail.com>
 <20110530105937.GB20133@elte.hu>
 <BANLkTimhMuN03qABgs0+Z+yti-rco5V82Q@mail.gmail.com>
 <20110530121532.GH22324@elte.hu>
 <BANLkTiktxzeUQ5aoSbzJ1W=HK3KH3y85jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTiktxzeUQ5aoSbzJ1W=HK3KH3y85jg@mail.gmail.com>
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

> But I'll make the option control just time() instead of all three.
> That will also reduce the size of the patch :)

Yes :-)

Thanks,

	Ingo
