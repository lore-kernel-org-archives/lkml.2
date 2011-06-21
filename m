Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1FUXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:25:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47700 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab1FUXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:25:24 -0400
Date: Tue, 21 Jun 2011 16:25:07 -0700 (PDT)
Message-Id: <20110621.162507.453473443486815179.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove mm.h inclusion from netdevice.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110616210134.GA18026@p183.telecom.by>
References: <20110616210134.GA18026@p183.telecom.by>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 21 Jun 2011 16:25:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 17 Jun 2011 00:01:34 +0300

> Remove linux/mm.h inclusion from netdevice.h -- it's unused (I've checked manually).
> 
> To prevent mm.h inclusion via other channels also extract "enum dma_data_direction"
> definition into separate header. This tiny piece is what gluing netdevice.h with mm.h
> via "netdevice.h => dmaengine.h => dma-mapping.h => scatterlist.h => mm.h".
> Removal of mm.h from scatterlist.h was tried and was found not feasible
> on most archs, so the link was cutoff earlier.
> 
> Hope people are OK with tiny include file.
> 
> Note, that mm_types.h is still dragged in, but it is a separate story.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

I've applied this, thanks.
