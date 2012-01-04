Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2ADCcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:32:03 -0500
Received: from ozlabs.org ([203.10.76.45]:36051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab2ADCcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:32:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: log OOT_MODULE tainting
In-Reply-To: <alpine.LNX.2.00.1201030944270.24984@pobox.suse.cz>
References: <alpine.LNX.2.00.1201021456120.24984@pobox.suse.cz> <87zke5en2z.fsf@rustcorp.com.au> <alpine.LNX.2.00.1201030944270.24984@pobox.suse.cz>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jan 2012 12:22:51 +1030
Message-ID: <87d3b0dyj0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012 09:47:02 +0100 (CET), Jiri Kosina <jkosina@suse.cz> wrote:
> On Tue, 3 Jan 2012, Rusty Russell wrote:
> 
> > > Follow what we do with other taints and output a message into kernel ring 
> > > buffer once tainting a kernel because out-of-tree module is being loaded.
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > I don't like this, actually.  There's a wish among some distributions to
> > know that OOT modules are in use in panic messages, but not by others.
> > Certainly, there's no reason to warn the user.
> 
> I do get your point, but it seems to me that we are at least not 
> consistent here. Why would we then log messages in cases of 
> TAINT_FORCED_MODULE for example? The user knows that he has forced the 
> module load, right?

Agreed, we're not consistent at all.  But a forcing a module is such a
weird and risky thing to do, the user can ignore a warning message.

Cheers,
Rusty.
