Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1CTMxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 08:53:01 -0400
Received: from www.tglx.de ([62.245.132.106]:55105 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab1CTMxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 08:53:00 -0400
Date: Sun, 20 Mar 2011 13:52:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [000/474] 2.6.33.8-longterm review
In-Reply-To: <AANLkTi=q-HEBKFe=DLXC36Acxd_LqgfYs=66wxs013Ac@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103201351570.2787@localhost6.localdomain6>
References: <20110317213822.GA27980@kroah.com> <alpine.LFD.2.00.1103180942531.2787@localhost6.localdomain6> <AANLkTi=q-HEBKFe=DLXC36Acxd_LqgfYs=66wxs013Ac@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Mar 2011, Remy Bohmer wrote:

> Hi,
> 
> 2011/3/18 Thomas Gleixner <tglx@linutronix.de>:
> > On Thu, 17 Mar 2011, Greg KH wrote:
> >
> >> Yeah, I know what you are thinking, "What, 2.6.33, are you crazy?"
> >
> > Aren't we all crazy ?
> >
> >> I'd prefer it if you didn't answer that question...
> >
> > Too late. You should have put this before the question.
> >
> >> So, if you are using .33, please give this patch a test and let me know
> >> if I've messed up anything (hint, I think I did, it's up to you to
> >> figure it out, consider it a test to see if anyone actually cares about
> >> this kernel version.)
> >
> > We'll pull it into rt and figure out what breaks.
> 
> Can you please elaborate somewhat on the status of the RT-patchset
> development for 2.6.38 and on?

Working on it.

> It is silent about it for quite a while now, and actually the gap
> between mainstream and the latest RT has never been this big before...
> Are there major complications, lack on time or hands? Can I help ?

I concentrated on getting stuff upstream and reworking to make it more
palatable and maintainable.

Thanks,

	tglx
