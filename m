Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2KSBKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 20:10:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51623 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KSBKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 20:10:18 -0500
Date: Mon, 19 Nov 2012 01:10:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
Message-ID: <20121119011013.GJ16916@ZenIV.linux.org.uk>
References: <20121118.140332.1273544560009594278.davem@davemloft.net>
 <20121118195921.GH16916@ZenIV.linux.org.uk>
 <20121118210253.GI16916@ZenIV.linux.org.uk>
 <20121118.161833.985081954687473276.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121118.161833.985081954687473276.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 04:18:33PM -0500, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sun, 18 Nov 2012 21:02:53 +0000
> 
> > Are you OK with the patch below?  Should be the minimal fix, getting
> > rid of those segfaults and converting to usual semantics here...
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Yep, looks fine:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Er...  So which tree should that go through?  sparc or signal?  There's
a similar microblaze patch and a few more of the "do_sigaltstack() takes
userland pointer" variety, so I can put together a pile in
signal.git#for-linus, but if you prefer that to go through sparc tree,
I'm fine with that...
