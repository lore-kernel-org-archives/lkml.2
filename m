Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab0FEUh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:37:28 -0400
Received: from ist.d-labs.de ([213.239.218.44]:36586 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab0FEUh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:37:27 -0400
Date: Sat, 5 Jun 2010 22:37:08 +0200
From: Florian Mickler <florian@mickler.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100605223708.7d8ff451@schatten.dmk.lab>
In-Reply-To: <alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<alpine.LFD.2.00.1006031630300.8175@i5.linux-foundation.org>
	<20100603234634.GA21831@elte.hu>
	<alpine.LFD.2.00.1006031856420.8175@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 19:16:55 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> The thing is, unless there is some _really_ deep other reason to do 
> something like this, I still think it's total overdesign to push any 
> knowledge/choices like this into the scheduler. I'd rather keep things way 
> more independent, less tied to each other and to deep kernel subsystems.
> 
> IOW, my personal opinion is that somethng like a suspend (blocker or not) 
> decision simply shouldn't be important enough to be tied into the 
> scheduler. Especially not if it could just be its own layer.
> 
> That said, as far as I know, the Android people have mostly been looking 
> at the suspend angle from a single-core standpoint. And I'm not at all 
> convinced that they should hijack the existing "/sys/power/state" thing 
> which is what I think they do now.
> 
> And those two things go together. The /sys/power/state thing is a global 
> suspend - which I don't think is appropriate for a opportunistic thing in 
> the first place, especially for multi-core.
> 

This sounds right. 

If there is soo much need for a better solution, it will emerge. With
merged suspend blockers or not.

Just my 2 cents.

> 			Linus

Cheers,
Flo
