Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab2GFLFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:05:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41843 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab2GFLFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:05:00 -0400
Date: Fri, 6 Jul 2012 13:04:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Revert the buffered-printk() changes for now
Message-ID: <20120706110454.GD19552@gmail.com>
References: <20120622145402.8047a669.akpm@linux-foundation.org>
 <20120623061313.GA21895@gmail.com>
 <1340452052.1784.40.camel@mop>
 <20120625090933.GD24512@gmail.com>
 <CAPXgP10E7HNDQ73ZFyb4EyDVBko2yXs8Rw0KOSKukGUpSBSz_g@mail.gmail.com>
 <20120625140748.GB1301@gmail.com>
 <1340635734.27036.327.camel@gandalf.stny.rr.com>
 <20120625164033.GA14000@kroah.com>
 <20120627055255.GC14913@gmail.com>
 <1340776788.16533.44.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340776788.16533.44.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-06-27 at 07:52 +0200, Ingo Molnar wrote:
> > what is left are over 50,000 
> > call sites of bragging and debugging code, occasionally massaged 
> > to be somewhat user friendly.
> 
> Bragging.  Silly.  A _very_ small percent of
> printks are "look at me" messages so I think that's
> a ridiculously poor argument.
> 
> Most of the printks are announcement and error
> logging notifications.

As I said, 'bragging and debugging code'.

Thanks,

	Ingo
