Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab2JWREU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 13:04:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42143 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131Ab2JWRER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 13:04:17 -0400
Date: Tue, 23 Oct 2012 13:04:15 -0400 (EDT)
Message-Id: <20121023.130415.2072105034807211296.davem@davemloft.net>
To: zhanghonghui@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        edumazet@google.com
Subject: Re: [PATCH] netlink: cleanup the unnecessary return value check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1350980483-4992-1-git-send-email-zhanghonghui@huawei.com>
References: <1350980483-4992-1-git-send-email-zhanghonghui@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <zhanghonghui@huawei.com>
Date: Tue, 23 Oct 2012 16:21:23 +0800

> From: Hans Zhang <zhanghonghui@huawei.com>
> 
> It's no needed to check the return value of tab since the NULL situation
> has been handled already, and the rtnl_msg_handlers[PF_UNSPEC] has been
> initialized as non-NULL during the rtnetlink_init().
> 
> Signed-off-by: Hans Zhang <zhanghonghui@huawei.com>

Applied.
