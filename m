Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2HaUOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:14:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53205 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab2HaUOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:14:46 -0400
Date: Fri, 31 Aug 2012 16:14:43 -0400 (EDT)
Message-Id: <20120831.161443.124994431345620659.davem@davemloft.net>
To: gaowanlong@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] net:atm:fix up ENOIOCTLCMD error handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346052196-32682-3-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1346052196-32682-3-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Date: Mon, 27 Aug 2012 15:23:13 +0800

> At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
> translated as ENOTTY to user mode.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Applied to net-next, thanks.
