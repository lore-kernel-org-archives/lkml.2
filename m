Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322Ab2KCCAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 22:00:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49514 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2KCCAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 22:00:35 -0400
Date: Fri, 02 Nov 2012 22:00:33 -0400 (EDT)
Message-Id: <20121102.220033.278425350670801966.davem@davemloft.net>
To: joe@perches.com
Cc: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] ethernet: Convert dev_printk(KERN_<LEVEL> to
 dev_<level>(
From: David Miller <davem@davemloft.net>
In-Reply-To: <78c3d489101b08588cb067181171eb070bdac756.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
	<78c3d489101b08588cb067181171eb070bdac756.1351411047.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun, 28 Oct 2012 01:05:48 -0700

> dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
> and reducing object size is good.
> Coalesce formats for easier grep.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I forgot the other day so indicate that I applied this to
net-next, thanks.
