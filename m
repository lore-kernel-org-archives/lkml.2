Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2CNAcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:32:04 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:52337 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417Ab2CNAcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:32:01 -0400
Date: Tue, 13 Mar 2012 20:31:57 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@shadowen.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Suggest pr_<level> over printk(KERN_<LEVEL>
Message-ID: <20120314003157.GA15379@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, Andy Whitcroft <apw@shadowen.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20120301.222316.1877216960521396397.davem@davemloft.net>
 <20120301.222604.1508242694024394849.davem@davemloft.net>
 <1330661602.1939.13.camel@joe2Laptop>
 <1330666534.1939.19.camel@joe2Laptop>
 <1330667673.1939.22.camel@joe2Laptop>
 <1331619783.7100.8.camel@joe2Laptop>
 <20120313120514.GA17538@thunk.org>
 <20120313145517.f4fcae46.akpm@linux-foundation.org>
 <20120313220144.GD11969@thunk.org>
 <20120313150316.6ae19b95.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313150316.6ae19b95.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 03:03:16PM -0700, Andrew Morton wrote:
> > Sure but if a particular kernel file or subsystem is _not_ using
> > pr_foo(), having a checkpatch which tries to force everyone to use
> > pr_foo() is going to be really annoying to me as a maintainer...
> 
> Yes, that's what I fear.  That's why I'm testing it...

Perhaps the answer is a ".checkpatch_ignore" file that can be
maintained by maintainers in each directory to suppress specific
checkpatch warnings that the maintainers don't agree with.  That way
we don't have to worry about checkpatch maintainers try to impose
their pet programming style preferences on maintainers who don't want
to get random trivial style-fixing patches from well-meaning kernel
newbies...

						- Ted
