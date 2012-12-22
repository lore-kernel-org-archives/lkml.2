Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab2LVIBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 03:01:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49145 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2LVIBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 03:01:14 -0500
Date: Sat, 22 Dec 2012 00:01:11 -0800 (PST)
Message-Id: <20121222.000111.1132195626602429566.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, wg@grandegger.com, netdev@vger.kernel.org
Subject: Re: [PATCH 03/25] sja1000: don't use [delayed_]work_pending()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1356141435-17340-4-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
	<1356141435-17340-4-git-send-email-tj@kernel.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 21 Dec 2012 17:56:53 -0800

> There's no need to test whether a (delayed) work item in pending
> before queueing, flushing or cancelling it.  Most uses are unnecessary
> and quite a few of them are buggy.
> 
> Remove unnecessary pending tests from sja1000.  Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
> Please let me know how this patch should be routed.  I can take it
> through the workqueue tree if necessary.

I would suggest just taking it via the workqueue tree, thanks Tejun.
