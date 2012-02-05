Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2BEWqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:46:11 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43939 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab2BEWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:46:08 -0500
Date: Sun, 05 Feb 2012 17:45:59 -0500 (EST)
Message-Id: <20120205.174559.545816004267807280.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net/hyperv: Correct the assignment in
 netvsc_recv_callback()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328479990-1436-2-git-send-email-haiyangz@microsoft.com>
References: <1328479990-1436-1-git-send-email-haiyangz@microsoft.com>
	<1328479990-1436-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 05 Feb 2012 14:46:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Sun,  5 Feb 2012 14:13:09 -0800

> The first assignment to variable "net" is wrong, but overridden by the
> latter assignments. So the bug isn't manifested.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Applied.
