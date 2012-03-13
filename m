Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2CMVzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:55:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759927Ab2CMVzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:55:19 -0400
Date: Tue, 13 Mar 2012 14:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@shadowen.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-Id: <20120313145517.f4fcae46.akpm@linux-foundation.org>
In-Reply-To: <20120313120514.GA17538@thunk.org>
References: <20120302025554.GA13493@joana>
	<20120301.221643.881299898523907213.davem@davemloft.net>
	<20120301.222316.1877216960521396397.davem@davemloft.net>
	<20120301.222604.1508242694024394849.davem@davemloft.net>
	<1330661602.1939.13.camel@joe2Laptop>
	<1330666534.1939.19.camel@joe2Laptop>
	<1330667673.1939.22.camel@joe2Laptop>
	<1331619783.7100.8.camel@joe2Laptop>
	<20120313120514.GA17538@thunk.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 08:05:14 -0400
"Ted Ts'o" <tytso@mit.edu> wrote:

> On Mon, Mar 12, 2012 at 11:23:03PM -0700, Joe Perches wrote:
> > Suggest the shorter pr_<level> instead of printk(KERN_<LEVEL>.
> > 
> > Prefer to use pr_<level> over bare printks.
> > Prefer to use pr_warn over pr_warning.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Is this even worth a warning?   I don't think so....

mm...  probably.  It's not a thing I ever bother mentioning in review,
but I guess pr_foo() is a bit denser, and doing the same thing in two
different ways is always an irritant.

I'll put the patch in my tree for a while and see how irritating I find
it ;)

