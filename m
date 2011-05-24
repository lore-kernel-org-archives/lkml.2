Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1EXTls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:41:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44701 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1EXTlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:41:47 -0400
Date: Tue, 24 May 2011 15:40:33 -0400 (EDT)
Message-Id: <20110524.154033.97802937258958106.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] seqlock: get rid of SEQLOCK_UNLOCKED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306238888.3026.31.camel@edumazet-laptop>
References: <1306238888.3026.31.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 May 2011 12:40:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 24 May 2011 14:08:08 +0200

> All static seqlock should be initialized with the lockdep friendly
> __SEQLOCK_UNLOCKED() macro.
> 
> Remove legacy SEQLOCK_UNLOCKED() macro.
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
