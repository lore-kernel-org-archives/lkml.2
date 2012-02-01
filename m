Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2BATn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:56 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:33793 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2BATnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:53 -0500
Date: Wed, 01 Feb 2012 14:42:26 -0500 (EST)
Message-Id: <20120201.144226.1972220684681132136.davem@davemloft.net>
To: asharma@fb.com
Cc: joe@perches.com, bhelgaas@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, glommer@parallels.com, mingo@elte.hu,
        christoph.paasch@uclouvain.be
Subject: Re: [PATCH] net: Disambiguate kernel message
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120131220521.GA1505@dev3310.snc6.facebook.com>
References: <1328043341.8702.3.camel@joe2Laptop>
	<20120131.161535.422381201029777577.davem@davemloft.net>
	<20120131220521.GA1505@dev3310.snc6.facebook.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 01 Feb 2012 11:42:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Sharma <asharma@fb.com>
Date: Tue, 31 Jan 2012 14:05:22 -0800

> From: Arun Sharma <asharma@fb.com>
> Date: Mon, 30 Jan 2012 14:16:06 -0800
> Subject: [PATCH] net: Disambiguate kernel message
> 
> Some of our machines were reporting:
> 
> TCP: too many of orphaned sockets
> 
> even when the number of orphaned sockets was well below the
> limit.
> 
> We print a different message depending on whether we're out
> of TCP memory or there are too many orphaned sockets.
> 
> Also move the check out of line and cleanup the messages
> that were printed.
> 
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Suggested-by: Mohan Srinivasan <mohan@fb.com>

Applied, thanks.
