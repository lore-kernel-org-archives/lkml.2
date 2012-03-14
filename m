Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab2CNArJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:47:09 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38393 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759375Ab2CNArH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:47:07 -0400
Message-ID: <1331686026.24613.6.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Mar 2012 17:47:06 -0700
In-Reply-To: <20120314003157.GA15379@thunk.org>
References: <20120301.222316.1877216960521396397.davem@davemloft.net>
	 <20120301.222604.1508242694024394849.davem@davemloft.net>
	 <1330661602.1939.13.camel@joe2Laptop> <1330666534.1939.19.camel@joe2Laptop>
	 <1330667673.1939.22.camel@joe2Laptop> <1331619783.7100.8.camel@joe2Laptop>
	 <20120313120514.GA17538@thunk.org>
	 <20120313145517.f4fcae46.akpm@linux-foundation.org>
	 <20120313220144.GD11969@thunk.org>
	 <20120313150316.6ae19b95.akpm@linux-foundation.org>
	 <20120314003157.GA15379@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 20:31 -0400, Ted Ts'o wrote:
> On Tue, Mar 13, 2012 at 03:03:16PM -0700, Andrew Morton wrote:
> > > Sure but if a particular kernel file or subsystem is _not_ using
> > > pr_foo(), having a checkpatch which tries to force everyone to use
> > > pr_foo() is going to be really annoying to me as a maintainer...
> > 
> > Yes, that's what I fear.  That's why I'm testing it...
> 
> Perhaps the answer is a ".checkpatch_ignore" file that can be
> maintained by maintainers in each directory to suppress specific
> checkpatch warnings that the maintainers don't agree with.  That way
> we don't have to worry about checkpatch maintainers try to impose
> their pet programming style preferences on maintainers who don't want
> to get random trivial style-fixing patches from well-meaning kernel
> newbies...

Or add an I: line to MAINTAINERS

though perhaps it's better to agree on a style.

I did send a few fixes and a style consolidation patch
for ext4 with no reply awhile ago:

https://lkml.org/lkml/2011/8/2/41


