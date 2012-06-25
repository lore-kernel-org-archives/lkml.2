Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab2FYOHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:07:55 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48595 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab2FYOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:07:53 -0400
Date: Mon, 25 Jun 2012 16:07:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Revert the buffered-printk() changes for now
Message-ID: <20120625140748.GB1301@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
 <20120622145402.8047a669.akpm@linux-foundation.org>
 <20120623061313.GA21895@gmail.com>
 <1340452052.1784.40.camel@mop>
 <20120625090933.GD24512@gmail.com>
 <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay@vrfy.org> wrote:

> > Kernel policy is that kernel bugs introduced during the 
> > merge window are fixed by those who introduced them, or the 
> > changes get reverted. The kernel project uses a very 
> > user-friendly process to resolve regressions and in the 
> > worst case you as a developer have to suffer your changes 
> > reverted. Obviously timely fixes are preferred over invasive 
> > reverts.
> 
> That's true. this change is a trade, and the kernel self-tests 
> print-continuation-line-and-let-the-kernel-crash is currently 
> affected by the hugely improved integrity and reliability of 
> all the "normal" users.

Sigh, which part of the "no regressions" policy did you not 
understand?

Even if we ignored regressions (which we don't), you'd *STILL* 
be wrong: using printk to debug crashes (and to develop code in 
general) is one of its earliest and I'd say most important role.

And when do we need printk() output? Most of the time only when 
there's a problem with the system - such as a crash.

System logging is an arguably secondary role, and it should not 
degrade printk()s primary role.

Your flippant attitude towards printk quality is really sad.

Thanks,

	Ingo
