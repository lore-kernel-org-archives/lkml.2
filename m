Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2FURNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:13:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923Ab2FURNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:13:47 -0400
Date: Thu, 21 Jun 2012 10:13:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120621171338.GF3270@kroah.com>
References: <20120614154153.GD17140@kroah.com>
 <1339693625.13377.242.camel@gandalf.stny.rr.com>
 <20120615042233.GA10973@localhost>
 <20120615043017.GA9587@kroah.com>
 <20120615120430.GB23681@gmail.com>
 <20120615231318.GD8205@kroah.com>
 <1339804415.25903.63.camel@gandalf.stny.rr.com>
 <20120618230337.GB23627@kroah.com>
 <1340069326.25903.177.camel@gandalf.stny.rr.com>
 <20120620122549.GA10561@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620122549.GA10561@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 02:25:49PM +0200, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Mon, 2012-06-18 at 16:03 -0700, Greg Kroah-Hartman wrote:
> > 
> > > > Actually, I think that patch really should go mainline, and give others
> > > > some of the luxury that us -rt folks enjoy.
> > > 
> > > That would be good.
> > 
> > Maybe I'll package that up if Ingo has no objections.
> 
> No objection, but I see it as an independent improvement.
> 
> Please also make printk() more useful out of box and fix the 
> flushing bug ...
> 
> So mind re-sending the latest version of your printk flushing 
> fix? I'll apply it for v3.5-rc if other trees won't pick it up.

I'll be glad to pick it up, just make it work properly :)

thanks,

greg k-h
