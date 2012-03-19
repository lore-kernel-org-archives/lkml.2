Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2CSU7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:59:24 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38907 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2CSU7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:59:22 -0400
Date: Mon, 19 Mar 2012 16:58:12 -0400 (EDT)
Message-Id: <20120319.165812.97446322080587886.davem@davemloft.net>
To: joe@perches.com
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] if_vlan: Remove VLAN_ETH_ALEN define and the 1 use
 of it
From: David Miller <davem@davemloft.net>
In-Reply-To: <89fdd9882355bacb4771a0c6c1f7a6ed43ab3f8b.1332128181.git.joe@perches.com>
References: <cover.1332128181.git.joe@perches.com>
	<89fdd9882355bacb4771a0c6c1f7a6ed43ab3f8b.1332128181.git.joe@perches.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 13:58:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 18 Mar 2012 20:37:56 -0700

> Just use ETH_ALEN.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
