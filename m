Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab2FPNcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:32:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59741 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2FPNca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:32:30 -0400
Date: Sat, 16 Jun 2012 15:32:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>,
        ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120616133221.GA31570@somewhere>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
 <20120615233413.GB8894@kroah.com>
 <alpine.LFD.2.02.1206161103320.3086@ionos>
 <20120616072906.7469ec24@tpl.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616072906.7469ec24@tpl.lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:29:06AM -0600, Jonathan Corbet wrote:
> On Sat, 16 Jun 2012 12:50:05 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > A good start would be if you could convert your kernel statistics into
> > accounting the consolidation effects of contributions instead of
> > fostering the idiocy that corporates have started to measure themself
> > and the performance of their employees (I'm not kidding, it's the sad
> > reality) with line and commit count statistics.
> 
> I would dearly love to come up with a way to measure "real work" in
> some fashion; I've just not, yet, figured out how to do that.  I do
> fear that the simple numbers we're able to generate end up creating the
> wrong kinds of incentives.
> 
> Any thoughts on how to measure "consolidation effects"?  I toss out
> numbers on code removal sometimes, but that turns out to not be a whole
> lot more useful than anything else on its own.

I fear there is no reliable automated way to measure that :)
