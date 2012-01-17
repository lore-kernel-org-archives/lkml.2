Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2AQPSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:18:35 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54544 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2AQPSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:18:34 -0500
Date: Tue, 17 Jan 2012 10:16:22 -0500 (EST)
Message-Id: <20120117.101622.533172793237678130.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] move sock_update_memcg outside of CONFIG_INET
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326701079-10331-1-git-send-email-glommer@parallels.com>
References: <1326701079-10331-1-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 07:16:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Mon, 16 Jan 2012 12:04:39 +0400

> Although only used currently for tcp sockets, this function
> is now used in common sock code (for sock_clone())
> 
> Commit 475f1b52645a29936b9df1d8fcd45f7e56bd4a9f moved the
> declaration of sock_update_clone() to inside sock.c, but
> this only fixes the problem when CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> is also not defined.
> 
> This patch here is verified to fix both problems, although
> reverting the previous one is not necessary.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Applied, but with a fixed subject line, you must always prefix your
subject line with the subsystem your change is being made to.  In
this case simply "net: " would have been sufficient, so that's what
I added.
