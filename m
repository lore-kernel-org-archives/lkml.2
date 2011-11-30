Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1K3FmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:42:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46981 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1K3FmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:42:23 -0500
Date: Wed, 30 Nov 2011 00:40:10 -0500 (EST)
Message-Id: <20111130.004010.1075431174091251814.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: akpm@linux-foundation.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111130155226.b571cfd7887f03f9e8e1285b@canb.auug.org.au>
References: <20111130155226.b571cfd7887f03f9e8e1285b@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 29 Nov 2011 21:40:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 30 Nov 2011 15:52:26 +1100

> And many more similar.
> 
> Caused (or exposed) by commit 9222aa56c0ce
> ("include/net/netprio_cgroup.h: various fixes") from the akpm tree.
> 
> I have reverted that commit for today.

Andrew, please submit networking bug fixes to the networking maintainers
in order to avoid problems like this in the future.

Unlike other subsystems, I guarentee to handle it within 24 hours, often
much faster.

Thanks.
