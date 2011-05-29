Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1E2T5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:57:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50901 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab1E2T5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:57:20 -0400
Date: Sun, 29 May 2011 21:56:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110529195657.GF13539@elte.hu>
References: <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu>
 <4DDFE52D.4070308@zytor.com>
 <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
 <20110528121820.GB12059@elte.hu>
 <4DE19DC3.7090106@zytor.com>
 <20110529124702.GE26627@elte.hu>
 <4DE28E1E.60207@zytor.com>
 <20110529184409.GA9835@elte.hu>
 <4DE295FE.1020506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE295FE.1020506@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/29/2011 11:44 AM, Ingo Molnar wrote:
> > 
> > We could put a 2MB hole between end of text (end of X) and start of 
> > readonly data (start of NX), and another 2MB hole between end of 
> > readonly and start of data.
> > 
> 
> It still means you have memory which is X-mapped when it doesn't need to
> be, since there will be RAM in that region.

But it ought to be rather harmless in this particular case, because 
the high alias addresses are all randomized!

Thanks,

	Ingo
