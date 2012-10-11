Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab2JKAe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:34:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56944 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2JKAex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:34:53 -0400
Date: Wed, 10 Oct 2012 20:34:51 -0400 (EDT)
Message-Id: <20121010.203451.2057992842427697875.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121010051110.GC2616@ZenIV.linux.org.uk>
References: <20121008.161806.2146082252793236167.davem@davemloft.net>
	<20121010051110.GC2616@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Wed, 10 Oct 2012 06:11:10 +0100

> sparc64: fix ptrace interaction with force_successful_syscall_return()
>     
> we want syscall_trace_leave() called on exit from any syscall;
> skipping its call in case we'd done force_successful_syscall_return()
> is broken...
>     
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

My eyes say this one is good, I'm testing it now and will push to
Linus if I don't hit any problems.

Thanks!
