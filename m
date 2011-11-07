Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1KGDia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 22:38:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55010 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1KGDi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 22:38:28 -0500
Date: Sun, 06 Nov 2011 22:36:19 -0500 (EST)
Message-Id: <20111106.223619.1348742215191441592.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregory.v.rose@intel.com,
        jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the origin tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111107134706.3e7fc633f913b5e155153127@canb.auug.org.au>
References: <20111107101202.96fcb76d580e5265bd99aeee@canb.auug.org.au>
	<20111106.205259.1237400984015921904.davem@davemloft.net>
	<20111107134706.3e7fc633f913b5e155153127@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 06 Nov 2011 19:36:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 Nov 2011 13:47:06 +1100

>> If you just revert the commit in origin from -next, then you will get
>> conflicts with you pull the net.git tree in.
> 
> I got no conflicts when I merged in the net tree and can see no fix for
> this problem in the net tree.  My current head of the net tree is 1a6422f
> "etherh: Add MAINTAINERS entry for etherh".

Ok, Jeff please take a look at this and send me a fix soon.

Thanks.
