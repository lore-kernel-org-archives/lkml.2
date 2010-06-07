Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0FGNUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:20:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:39423 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab0FGNUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:20:40 -0400
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Peter Zijlstra <peterz@infradead.org>
To: Brian Swetland <swetland@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
In-Reply-To: <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
References: <1275834706.7227.545.camel@mulgrave.site>
	 <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
	 <1275844114.7227.552.camel@mulgrave.site>
	 <20100606190525.GA20517@infradead.org>
	 <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
	 <20100606192405.GA7559@infradead.org>
	 <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 15:20:30 +0200
Message-ID: <1275916830.1645.566.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 12:58 -0700, Brian Swetland wrote:
> Somebody will have to broker a deal with the frameworks/apps folks to
> get rid of the binder.  They like it a lot.  Of course if somebody
> built a drop-in replacement for the userspace side that didn't require
> a kernel driver, had the same performance characteristics, solved the
> same problems, etc, they could probably make an argument for it (or
> just provide it as a drop-in replacement for people who want a more
> "pure" linux underneath Android, even if we didn't pick it up). 

So what's up with this Binder stuff, from what I can see its just
yet-another-CORBA. Why does it need a kernel part at all, can't you
simply run with a user-space ORB instead?

I really don't get why people keep re-inventing CORBA, there's some
really nice (free) ORBs out there, like:

  http://www.cs.wustl.edu/~schmidt/TAO.html



