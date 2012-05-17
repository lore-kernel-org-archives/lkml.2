Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2EQIed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:34:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57437 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab2EQIe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:34:29 -0400
Date: Thu, 17 May 2012 04:34:17 -0400 (EDT)
Message-Id: <20120517.043417.1244517151794670965.davem@davemloft.net>
To: jchapman@katalix.com
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: l2tp: Standardize logging styles
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FB4ACD1.10509@katalix.com>
References: <1337198156.10019.8.camel@joe2Laptop>
	<4FB4ACD1.10509@katalix.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 01:34:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Thu, 17 May 2012 08:46:25 +0100

> This is a good improvement. Thanks!
> 
> Signed-off-by: James Chapman <jchapman@katalix.com>

James, please don't quote an entire patch when ACK'ing a patch like.
Do you realize that this makes the whole patch have to be processed by
every recipient subscribed to these mailing lists as well as sites
that monitor discussions on patches such as patchwork?

Even if you want to comment on some portions of the patch, you should
only quote the very specific hunks you wish to comment upon.

It is absolutely never appropriate to quote an entire patch in an
email response, really.

Anyways I'll apply this patch, thanks everyone.
