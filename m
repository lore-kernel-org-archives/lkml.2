Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab1GYT3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 15:29:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:51092 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1GYT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 15:29:06 -0400
Date: Mon, 25 Jul 2011 21:28:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
cc: Darren Hart <dvhart@linux.intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, mingo@elte.hu
Subject: Re: [PATCH v5] futex: Fix regression with read only mappings
In-Reply-To: <20110725152033.GA2275@BohrerMBP.rgmadvisors.com>
Message-ID: <alpine.LFD.2.02.1107252125270.2848@ionos>
References: <4E0C9911.7030907@linux.intel.com> <1309450892-30676-1-git-send-email-sbohrer@rgmadvisors.com> <20110725152033.GA2275@BohrerMBP.rgmadvisors.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jul 2011, Shawn Bohrer wrote:
> On Thu, Jun 30, 2011 at 11:21:32AM -0500, Shawn Bohrer wrote:
> > commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
> > parameter from get_futex_key()) in 2.6.33 fixed two problems:  First, It
> >  
> > -	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
> > +	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2, VERIFY_WRITE);
> >  	if (unlikely(ret != 0))
> >  		goto out;
> >  
> 
> Thomas,
> 
> What do I need to do to get this patch accepted?

First of all, please use proper quoting. It's a nuisance to page down
10 times to find the interesting new text of a mail :)

Seriously, I'm sorry, it fell from my radar. Thanks for the
reminder. It's on top of my tomorrow morning (brain usable) todo list
now.

Thanks,

	tglx
