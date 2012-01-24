Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2AXUtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:49:45 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41824 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2AXUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:49:44 -0500
Date: Tue, 24 Jan 2012 15:48:07 -0500 (EST)
Message-Id: <20120124.154807.720596846169960041.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yongjun_wei@trendmicro.com.cn
Subject: Re: [PATCH] net/hyperv: fix possible memory leak in
 do_set_multicast()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327436488-24114-1-git-send-email-haiyangz@microsoft.com>
References: <1327436488-24114-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 12:49:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 24 Jan 2012 12:21:28 -0800

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> do_set_multicast() may not free the memory malloc in
> netvsc_set_multicast_list().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
