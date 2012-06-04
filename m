Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852Ab2FDPvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:51:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40511 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2FDPvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:51:21 -0400
Date: Mon, 04 Jun 2012 11:51:19 -0400 (EDT)
Message-Id: <20120604.115119.568655178193939719.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 0/1] net/hyperv: Use wait_event on outstanding sends
 during device removal
From: David Miller <davem@davemloft.net>
In-Reply-To: <1338820532-2345-1-git-send-email-haiyangz@microsoft.com>
References: <1338820532-2345-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon,  4 Jun 2012 07:35:31 -0700

> This patch is targeting net-next tree (when it's available for check in).
> 
> Haiyang Zhang (1):
>   net/hyperv: Use wait_event on outstanding sends during device removal

Why in the world are you doing this?

This patch you are already asking me to apply to the 'net' tree, and
changes already will automatically propagate from 'net' to
'net-next' the next time I merge those trees.

So you never need to submit bug fixes twice, once for 'net' and
once for 'net-next' so please do not do it.
