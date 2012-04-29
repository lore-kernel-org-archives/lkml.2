Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2D2CXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 22:23:24 -0400
Received: from smtp.syd.comcen.com.au ([203.23.236.77]:2757 "EHLO
	smtp.syd.comcen.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab2D2CXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 22:23:23 -0400
Date: Sun, 29 Apr 2012 12:21:06 +1000
From: Chris Jones <chrisjones@spin.net.au>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: 3.1+ kernels unbootable
Message-ID: <20120429122106.044a1c88@ubuntu>
In-Reply-To: <20120425144452.32a803fe@notabene.brown>
References: <20120425124925.267056b5@ubuntu>
	<20120425132122.11280b66@notabene.brown>
	<20120425142001.2cb7a79e@ubuntu>
	<20120425144452.32a803fe@notabene.brown>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-comcen-MailScanner-Information: Please contact the ISP for more information
X-comcen-MailScanner: Found to be clean
X-comcen-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-1.965, required 4, AWL 0.54, BAYES_00 -2.60, RDNS_NONE 0.10)
X-comcen-MailScanner-From: chrisjones@spin.net.au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 14:44:52 +1000
NeilBrown <neilb@suse.de> wrote:

> 
> You have a couple of options here.
> 
> One is to use git-bisect to narrow down where the breakage is.  This
> means building about a dozen or a score of kernels and testing each
> one and then trying again.  If you are happy building your own
> kernels and have an afternoon to spare this is probably a good idea.
> There should be plenty of instruction on the web about how to do this
> but if you cannot find any feel free to ask.
> 
> The other is to try turning features off and debugging on.
> Many distros have some sort of "fail-safe" boot option which disables
> things like ACPI and known-problematic drivers... though with it
> failing so early most drives won't have even tried to run.  I'd guess
> an ACPI problem, but that is largely because I know almost nothing
> about ACPI so it is easy to blame it.  So try adding "acpi=off" to
> the boot args.
> 
> Linux has a thing called 'early_printk' which allows messages to be
> displayed even before the normal drivers are loaded.  I don't know
> much about enabling that on an x86 system (I use it a lot on ARM
> though).  You need it enabled when the kernel is compiled, and you
> need a boot arg to enable it too.  Maybe if you manage to enable
> that you might get some message printed.
> 
> Or maybe there is some other much more useful thing you can try and
> someone else will chime in soon and tell me I don't know what I'm
> talking about and explain in detail the right way so solve this
> problem - that would be awesome.
> 
> NeilBrown

I have tried all ACPI disabled options and also all safe-mode options,
among many other modes. Nothing has worked.

Now that Ubuntu 12.04 has gone gold, I might try the latest kernel in
that and see if anything has changed.

Thanks Neil.


Regards

Chris Jones
