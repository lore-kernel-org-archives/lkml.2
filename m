Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab1EMUCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:02:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55452 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1EMUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:02:15 -0400
Date: Fri, 13 May 2011 16:01:38 -0400 (EDT)
Message-Id: <20110513.160138.1477780250019480052.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: lkml@techboom.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: kernel BUG at net/ipv4/tcp_output.c:1006!
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305316058.3120.6.camel@edumazet-laptop>
References: <1305307633.3866.61.camel@edumazet-laptop>
	<4DCD86C0.9030904@techboom.com>
	<1305316058.3120.6.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 May 2011 13:01:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 13 May 2011 21:47:38 +0200

> I suspect we should push commit 2fceec13375e5d98 (tcp: len check is
> unnecessarily devastating, change to WARN_ON) to stable if not already
> done...
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2fceec13375e5d98
> 
> David, is this commit in your stable queue ?

No, but now it is.
