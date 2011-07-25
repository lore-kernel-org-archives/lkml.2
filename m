Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1GYOOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:14:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab1GYOOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:14:37 -0400
Date: Mon, 25 Jul 2011 16:13:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: x86 <x86@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 3.1?] x86: Remove useless stts/clts pair in __switch_to
Message-ID: <20110725141339.GC3297@elte.hu>
References: <CAObL_7EuFXbuxpz2bzKuEReyDHo+mBxDyJSf_rjBKpdnUmEzLQ@mail.gmail.com>
 <38f1d91a44c243a91e441a947fed4b076dcd4ca1.1311587947.git.luto@mit.edu>
 <20110725111224.GP28787@elte.hu>
 <CAObL_7GTfH58gfgppg=KzKf8ztShA4LRFoZ0HyDXZ9M5Dii2BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7GTfH58gfgppg=KzKf8ztShA4LRFoZ0HyDXZ9M5Dii2BA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

> > Also, if you are tempted by the prospect of possibly enabling 
> > vector instructions for the x86 kernel, we could try that too, 
> > and get multiple speedups for the price of having to debug the 
> > tree only once ;-)
> 
> I'll play with it.  I have some other cleanup / speedup ideas, too, 
> and I'll see where they go.  Given that the kernel doesn't really 
> use floating-point math, I'm not sure that gcc will do much unless 
> we turn on -ftree-vectorize, and that's a little scary.

It's indeed scary - but as long as it boots it would allow some 
baseline figures to be estimated - is there any win, and if yes, how 
much. It might be a complete dud in the end.

Thanks,

	Ingo
