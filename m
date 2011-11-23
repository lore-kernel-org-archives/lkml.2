Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1KWXrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:47:40 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40074 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1KWXri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:47:38 -0500
Date: Wed, 23 Nov 2011 18:44:25 -0500 (EST)
Message-Id: <20111123.184425.1412287327735765077.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: nhorman@tuxdriver.com, sfr@canb.auug.org.au, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111123150213.ed7257cb.akpm@linux-foundation.org>
References: <20111123150004.59be04eb36c480ec44edc9d5@canb.auug.org.au>
	<20111123120937.GB27968@hmsreliant.think-freely.org>
	<20111123150213.ed7257cb.akpm@linux-foundation.org>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 Nov 2011 15:44:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 23 Nov 2011 15:02:13 -0800

> Needs a thorough redo.  Please take a look at the other cgroup
> subsystem headers.  The basic pattern is
> 
> #ifdef CONFIG_FOO_CGROUP
> <definitions and declarations>
> #else
> <any needed stubs go here>
> #endif
> 
> And that's it.

I told Neil to put the stub in net/core/dev.c since that's the one and
only call site.
