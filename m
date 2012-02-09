Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2BIJLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:11:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42990 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2BIJLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:11:50 -0500
Message-ID: <1328778529.2374.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Memory issues with Opteron 6220
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, jk@novozymes.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
Date: Thu, 09 Feb 2012 10:08:49 +0100
In-Reply-To: <20120209083315.GA19380@elte.hu>
References: <20120208143741.GB28486@otto.nzcorp.net>
	 <20120209083315.GA19380@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 février 2012 à 09:33 +0100, Ingo Molnar a écrit :
> * Anders Ossowicki <aowi@novozymes.com> wrote:
> 
> > Hey,
> > 
> > We're seeing unexpected slowdowns and other memory issues with a new system.
> > Enough to render it unusable. For example:
> > 
> > Error: open3: fork failed: Cannot allocate memory
> > 
> > at times where there's no real memory pressure:
> >                    total       used       free     shared    buffers     cached
> >       Mem:     132270720  131942388     328332          0     299768  103334420
> >       -/+ buffers/cache:   28308200  103962520
> >       Swap:      7811068      13760    7797308
> >
> > [...]
> 
> > The system is a Dell Poweredge R715, with two eight-core 
> > Opteron 6220 processors and 128G of memory. We have several 
> > similar systems, such as the one this should replace: R715, 
> > 2x8 core Opteron 6140, 128G memory, and they do not exhibit 
> > any similar symptoms.
> 
> 130 MB of RAM visible to Linux isn't the expected bootup default 
> indeed. Around 130 *GB* would be expected ...

Not sure what you mean, I see 128GB in the "free" output, as expected.

I dont understand why there are 4 nodes, given "The system is a Dell
Poweredge R715, with two eight-core Opteron 6220".

Or are each 6220 splitted on two nodes ?


