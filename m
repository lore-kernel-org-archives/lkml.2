Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1HIPvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:51:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58042 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1HIPvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:51:12 -0400
Date: Tue, 09 Aug 2011 08:50:49 -0700 (PDT)
Message-Id: <20110809.085049.747100276988072226.davem@davemloft.net>
To: stufever@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sandeep.Kumar@freescale.com, wangshaoyan.pt@taobao.com
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312904711-1855-1-git-send-email-wangshaoyan.pt@taobao.com>
References: <1312904711-1855-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 09 Aug 2011 08:51:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: stufever@gmail.com
Date: Tue,  9 Aug 2011 23:45:11 +0800

> From: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> 
>   drivers/net/gianfar_ethtool.c:765: warning: the frame size of 2048 bytes is larger than 1024 bytes
> 
> Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>

Would you be so kind as to actually acknowledge in some way the person
who found all the bugs in your first version of this patch? :-/

