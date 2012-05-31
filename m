Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2EaOEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:04:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496Ab2EaOEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:04:39 -0400
Date: Thu, 31 May 2012 10:04:32 -0400
From: Dave Jones <davej@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120531140432.GC1749@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120530214809.GA19223@redhat.com>
 <alpine.LFD.2.02.1205310938080.3231@ionos>
 <1338450985.2760.1270.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338450985.2760.1270.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 09:56:25AM +0200, Eric Dumazet wrote:
 > On Thu, 2012-05-31 at 09:52 +0200, Thomas Gleixner wrote:
 > > Dave,
 > > 
 > > On Wed, 30 May 2012, Dave Jones wrote:
 > > 
 > > > May 30 17:43:04 [ 1095.335659] NOHZ: local_softirq_pending 08
 > > > 
 > > > According to git, you ratelimited this back in 2007 with the message
 > > > "until we found the root cause of that problem."
 > > > 
 > > > Is this an old problem that has returned ?
 > > 
 > > Looks like.
 > >  
 > > > Maybe interesting note: Both machines I see this on regularly are Atom cpus,
 > > > and it's always '08'.
 > > 
 > > So it goes idle with NET_RX softirq pending. That really should not
 > > happen. I fear you need to fire up the tracer :)
 > 
 > It might be a bug in the network driver, a race with NAPI completion.
 > 
 > Dave, which net drivers run on these machines ?

r8169.

I got an email from someone else asking if I used Realtek drivers, which I thought
was an uncanny guess.

	Dave
