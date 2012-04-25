Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2DYSK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:10:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:40500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2DYSKy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:10:54 -0400
Message-ID: <1335377439.28150.272.camel@twins>
Subject: Re: [PATCH 2/2] math128, x86_64: Implement {mult,add}_u128 in 64bit
 asm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 25 Apr 2012 20:10:39 +0200
In-Reply-To: <CALCETrWBMUzG9KYVOQxwCLqnEQjRizz5k4tQW2=emfx1t8TgvA@mail.gmail.com>
References: <20120425111552.665217867@chello.nl>
	 <20120425112244.953956269@chello.nl>
	 <CALCETrWBMUzG9KYVOQxwCLqnEQjRizz5k4tQW2=emfx1t8TgvA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 11:02 -0700, Andy Lutomirski wrote:
> 
> > +static inline mul_u64_u64(u64 a, u64 b)
> 
> I think you're missing a return type and a 't'. 

argh, that's what you get for not actually compiling with an old enough
gcc :/

Fixed, thanks!
