Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab2CMWOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:14:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab2CMWOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:14:00 -0400
Date: Tue, 13 Mar 2012 15:03:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@shadowen.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-Id: <20120313150316.6ae19b95.akpm@linux-foundation.org>
In-Reply-To: <20120313220144.GD11969@thunk.org>
References: <20120302025554.GA13493@joana>
	<20120301.221643.881299898523907213.davem@davemloft.net>
	<20120301.222316.1877216960521396397.davem@davemloft.net>
	<20120301.222604.1508242694024394849.davem@davemloft.net>
	<1330661602.1939.13.camel@joe2Laptop>
	<1330666534.1939.19.camel@joe2Laptop>
	<1330667673.1939.22.camel@joe2Laptop>
	<1331619783.7100.8.camel@joe2Laptop>
	<20120313120514.GA17538@thunk.org>
	<20120313145517.f4fcae46.akpm@linux-foundation.org>
	<20120313220144.GD11969@thunk.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012 18:01:44 -0400
"Ted Ts'o" <tytso@mit.edu> wrote:

> On Tue, Mar 13, 2012 at 02:55:17PM -0700, Andrew Morton wrote:
> > 
> > mm...  probably.  It's not a thing I ever bother mentioning in review,
> > but I guess pr_foo() is a bit denser, and doing the same thing in two
> > different ways is always an irritant.
> 
> Sure but if a particular kernel file or subsystem is _not_ using
> pr_foo(), having a checkpatch which tries to force everyone to use
> pr_foo() is going to be really annoying to me as a maintainer...
> 

Yes, that's what I fear.  That's why I'm testing it...
