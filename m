Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2DRC0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:26:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60947 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2DRC0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:26:08 -0400
Date: Tue, 17 Apr 2012 22:24:14 -0400 (EDT)
Message-Id: <20120417.222414.1021293399100195501.davem@davemloft.net>
To: jkosina@suse.cz
Cc: sdyoung@vt220.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] arcnet: rimi: Fix device name in debug output
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1204161335420.16373@pobox.suse.cz>
References: <20120415153220.GA11631@vt220.org>
	<alpine.LNX.2.00.1204161335420.16373@pobox.suse.cz>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Apr 2012 19:24:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Mon, 16 Apr 2012 14:02:48 +0200 (CEST)

> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] arcnet: rimi: Fix device name in debug output
> 
> arcrimi_probe() calls BUGMSG() before register_netdev() happens. BUGMSG()
> itself prints dev->name, but as the format string hasn't been expanded by
> register_netdev() yet, the output contains bogus device name such as
> 
> 	arc%d: Given: node 00h, shmem 0h, irq 0
> 
> As we don't know the device name yet, just drop the prefix completely from
> the debugging messages.
> 
> Reported-by: Steven Young <sdyoung@vt220.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Applied, thanks.
