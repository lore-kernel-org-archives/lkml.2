Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab2EDOrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:47:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54001 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2EDOrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:47:35 -0400
Date: Fri, 04 May 2012 10:46:27 -0400 (EDT)
Message-Id: <20120504.104627.1862412386327343645.davem@davemloft.net>
To: hannes@cmpxchg.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120504094105.GD31780@cmpxchg.org>
References: <20120503152841.GA19918@cmpxchg.org>
	<20120503.130416.839732919427673590.davem@davemloft.net>
	<20120504094105.GD31780@cmpxchg.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 04 May 2012 07:46:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 4 May 2012 11:41:05 +0200

> I'll send patches to make everything use the same policy.

Thanks for doing this Johannes.
