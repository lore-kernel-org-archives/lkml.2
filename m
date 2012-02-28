Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2B1VI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:08:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49406 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2B1VIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:08:23 -0500
Date: Tue, 28 Feb 2012 16:08:18 -0500 (EST)
Message-Id: <20120228.160818.1053082393913813758.davem@davemloft.net>
To: joe@perches.com
Cc: trivial@kernel.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial next 1/9] sparc: Use vsprintf extention %pf
 with builtin_return_address
From: David Miller <davem@davemloft.net>
In-Reply-To: <5788cc9f8e5e9b3d8d2d7b78b2d1fb71325df773.1330454853.git.joe@perches.com>
References: <cover.1330454853.git.joe@perches.com>
	<5788cc9f8e5e9b3d8d2d7b78b2d1fb71325df773.1330454853.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 13:08:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 28 Feb 2012 10:49:30 -0800

> Emit the function name not the address when possible.
> 
> builtin_return_address() gives an address.  When building
> a kernel with CONFIG_KALLSYMS, emit the actual function
> name not the address.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to sparc-next, thanks Joe.
