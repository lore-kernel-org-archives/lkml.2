Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2DPTNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:13:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46985 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2DPTN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:13:29 -0400
Date: Mon, 16 Apr 2012 15:13:20 -0400 (EDT)
Message-Id: <20120416.151320.54915405482634916.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, joe@perches.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com
Subject: Re: Please fix or revert: [PATCH] checkpatch: add --strict tests
 for braces, comments and casts
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFzz9uu=R6zKy=r0JSpjCgtfoMCLvcLwdBXhhJ4=u-PagA@mail.gmail.com>
References: <20120416091719.GA4113@gmail.com>
	<20120416.142728.864894452301706752.davem@davemloft.net>
	<CA+55aFzz9uu=R6zKy=r0JSpjCgtfoMCLvcLwdBXhhJ4=u-PagA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 16 Apr 2012 12:13:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Apr 2012 12:09:12 -0700

> It looks unbalanced. If you want to save that vertical space, just use
> C++ style comments instead, for chissake! Then you save *two* lines,
> without the unbalanced thing, and just write it as
> 
>     // XXX
>     // YYY
> 
> which is much preferred.

I'm perfectly fine with this too.
