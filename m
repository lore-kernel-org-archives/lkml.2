Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1ERUsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:48:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57055 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab1ERUsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:48:30 -0400
Date: Wed, 18 May 2011 22:48:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/4] v6 Improve task->comm locking situation
Message-ID: <20110518204805.GA11427@elte.hu>
References: <1305682865-27111-1-git-send-email-john.stultz@linaro.org>
 <20110518062554.GB2945@elte.hu>
 <1305745409.2915.178.camel@work-vm>
 <20110518123335.62785884.akpm@linux-foundation.org>
 <20110518194811.GD6225@elte.hu>
 <20110518125616.b57e1881.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518125616.b57e1881.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 18 May 2011 21:48:11 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Dunno, %ptc ties into lowlevel sprintf() and takes a spinlock!
> 
> yup, that's a problem.

If the lock is removed it looks useful.

> > Oh, out of morbid curiosity, mind providing a log of bigger past incidents 
> > where you had to stick pins into a doll of me? (In private mail, if the list is 
> > too long ;-)
> 
> http://0.tqn.com/d/urbanlegends/1/0/m/B/porcupine2.jpg

That looks manageable! I was hoping not to end up like this:

  http://i.telegraph.co.uk/multimedia/archive/00675/china_needle404_675809c.jpg

Thanks,

	Ingo
