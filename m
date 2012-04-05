Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2DEASa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 20:18:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51265 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2DEAS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 20:18:29 -0400
Date: Wed, 04 Apr 2012 20:18:26 -0400 (EDT)
Message-Id: <20120404.201826.979310574458628758.davem@davemloft.net>
To: dave.jiang@intel.com
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] netdma: adding alignment check for NETDMA ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120404231046.20605.13918.stgit@djiang5-linux.ch.intel.com>
References: <20120404230749.20605.7000.stgit@djiang5-linux.ch.intel.com>
	<20120404231046.20605.13918.stgit@djiang5-linux.ch.intel.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 17:18:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 04 Apr 2012 16:10:46 -0700

> This is the fallout from adding memcpy alignment workaround for certain
> IOATDMA hardware. NetDMA will only use DMA engine that can handle byte align
> ops.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
