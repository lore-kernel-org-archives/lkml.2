Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1HAI5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:57:38 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35214 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1HAI5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:57:31 -0400
Date: Mon, 01 Aug 2011 01:57:18 -0700 (PDT)
Message-Id: <20110801.015718.1883456310806281501.davem@davemloft.net>
To: joe@perches.com
Cc: romieu@fr.zoreil.com, sorbica@icplus.com.tw, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipg: Use current logging styles
From: David Miller <davem@davemloft.net>
In-Reply-To: <2ee87bfccbbb5cf1776df6751b65e4a3110019f4.1311993468.git.joe@perches.com>
References: <2ee87bfccbbb5cf1776df6751b65e4a3110019f4.1311993468.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 01 Aug 2011 01:57:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 29 Jul 2011 19:38:14 -0700

> Add and use pr_fmt, pr_<level> and netdev_<level>.
> Convert printks with %[n].[n]x to %nx to be shorter
> and clearer.
> Consolidate printks to use a single printk rather
> than continued printks without KERN_CONT.
> Removed unnecessary trailing periods.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Queued up for net-next
