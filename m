Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2KSBaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 20:30:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KSBaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 20:30:09 -0500
Date: Sun, 18 Nov 2012 20:30:05 -0500 (EST)
Message-Id: <20121118.203005.151867624663051294.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121119011013.GJ16916@ZenIV.linux.org.uk>
References: <20121118210253.GI16916@ZenIV.linux.org.uk>
	<20121118.161833.985081954687473276.davem@davemloft.net>
	<20121119011013.GJ16916@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 19 Nov 2012 01:10:13 +0000

> On Sun, Nov 18, 2012 at 04:18:33PM -0500, David Miller wrote:
>> From: Al Viro <viro@ZenIV.linux.org.uk>
>> Date: Sun, 18 Nov 2012 21:02:53 +0000
>> 
>> > Are you OK with the patch below?  Should be the minimal fix, getting
>> > rid of those segfaults and converting to usual semantics here...
>> > 
>> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>> 
>> Yep, looks fine:
>> 
>> Acked-by: David S. Miller <davem@davemloft.net>
> 
> Er...  So which tree should that go through?  sparc or signal?  There's
> a similar microblaze patch and a few more of the "do_sigaltstack() takes
> userland pointer" variety, so I can put together a pile in
> signal.git#for-linus, but if you prefer that to go through sparc tree,
> I'm fine with that...

I'm happy to take it via my sparc tree, and I'll queue it up for
-stable as well. Can you resend it to me with a proper commit message?

Thanks a lot Al.
