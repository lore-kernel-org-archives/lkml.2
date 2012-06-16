Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab2FPN3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 09:29:03 -0400
Received: from tex.lwn.net ([70.33.254.29]:55144 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab2FPN3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 09:29:00 -0400
Date: Sat, 16 Jun 2012 07:29:06 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <greg@kroah.com>, ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120616072906.7469ec24@tpl.lwn.net>
In-Reply-To: <alpine.LFD.2.02.1206161103320.3086@ionos>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
	<20120615233413.GB8894@kroah.com>
	<alpine.LFD.2.02.1206161103320.3086@ionos>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2012 12:50:05 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> A good start would be if you could convert your kernel statistics into
> accounting the consolidation effects of contributions instead of
> fostering the idiocy that corporates have started to measure themself
> and the performance of their employees (I'm not kidding, it's the sad
> reality) with line and commit count statistics.

I would dearly love to come up with a way to measure "real work" in
some fashion; I've just not, yet, figured out how to do that.  I do
fear that the simple numbers we're able to generate end up creating the
wrong kinds of incentives.

Any thoughts on how to measure "consolidation effects"?  I toss out
numbers on code removal sometimes, but that turns out to not be a whole
lot more useful than anything else on its own.

Thanks,

jon
