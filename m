Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2DPRDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:03:01 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34094 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2DPRC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:02:56 -0400
Date: Mon, 16 Apr 2012 10:02:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: linux-next: build failure after merge of the rcu tree
Message-ID: <20120416170230.GB2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120416141117.6dfcc5931400fede4e8cbe58@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416141117.6dfcc5931400fede4e8cbe58@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041617-4242-0000-0000-0000015C0AF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 02:11:17PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the rcu tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/binfmt_misc.c: In function 'create_entry':
> fs/binfmt_misc.c:314:2: error: implicit declaration of function '_copy_from_user' [-Werror=implicit-function-declaration]
> 
> Caused by commit d17faaa53e2e ("fs: Silence bogus copy_to_user() build
> errors").  _copy_from_user() appears to only exist for the x86 and tile
> architectures ...
> 
> I have used the rcu tree from next-20120413 for today.

<red face>

It turns out that bug that commit d17faaa53e2e was working around has
been fixed in 3.4-rc2, so I have dropped that patch and reposted the
series.  Please accept my apologies for the hassle!

							Thanx, Paul

