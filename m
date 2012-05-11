Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946218Ab2EKVXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:23:54 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36724 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946149Ab2EKVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:23:53 -0400
Date: Fri, 11 May 2012 17:23:39 -0400 (EDT)
Message-Id: <20120511.172339.2007927803884694483.davem@davemloft.net>
To: mgorman@suse.de
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, a.p.zijlstra@chello.nl,
        michaelc@cs.wisc.edu, emunson@mgebm.net
Subject: Re: [PATCH 00/17] Swap-over-NBD without deadlocking V10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120511154540.GV11435@suse.de>
References: <1336657510-24378-1-git-send-email-mgorman@suse.de>
	<20120511.010445.1020972261904383892.davem@davemloft.net>
	<20120511154540.GV11435@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 May 2012 14:23:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mgorman@suse.de>
Date: Fri, 11 May 2012 16:45:40 +0100

> From my point of view, the ideal would be that all the patches go
> through akpm's tree or yours but that probably will cause merge
> difficulties.
> 
> Any recommendations?

I know there will be networking side conflicts very soon, it's not a
matter of 'if' but 'when'.

But the trick is that I bet the 'mm' and 'slab' folks are in a similar
situation.

In any event I'm more than happy to take it all in my tree.
