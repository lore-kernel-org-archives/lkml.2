Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2FTMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:25:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60790 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2FTMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:25:55 -0400
Date: Wed, 20 Jun 2012 14:25:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120620122549.GA10561@gmail.com>
References: <1339671715.13377.209.camel@gandalf.stny.rr.com>
 <20120614154153.GD17140@kroah.com>
 <1339693625.13377.242.camel@gandalf.stny.rr.com>
 <20120615042233.GA10973@localhost>
 <20120615043017.GA9587@kroah.com>
 <20120615120430.GB23681@gmail.com>
 <20120615231318.GD8205@kroah.com>
 <1339804415.25903.63.camel@gandalf.stny.rr.com>
 <20120618230337.GB23627@kroah.com>
 <1340069326.25903.177.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340069326.25903.177.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2012-06-18 at 16:03 -0700, Greg Kroah-Hartman wrote:
> 
> > > Actually, I think that patch really should go mainline, and give others
> > > some of the luxury that us -rt folks enjoy.
> > 
> > That would be good.
> 
> Maybe I'll package that up if Ingo has no objections.

No objection, but I see it as an independent improvement.

Please also make printk() more useful out of box and fix the 
flushing bug ...

So mind re-sending the latest version of your printk flushing 
fix? I'll apply it for v3.5-rc if other trees won't pick it up.

Thanks,

	Ingo
