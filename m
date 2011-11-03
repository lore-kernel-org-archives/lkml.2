Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1KCWJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:09:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36679 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab1KCWJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:09:09 -0400
Date: Thu, 03 Nov 2011 18:07:33 -0400 (EDT)
Message-Id: <20111103.180733.1492714521890801071.davem@davemloft.net>
To: sim@hostway.ca
Cc: eric.dumazet@gmail.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        davej@redhat.com, schwidefsky@de.ibm.com, mingo@elte.hu,
        netdev@vger.kernel.org, bazsi@balabit.hu, hidden@balabit.hu
Subject: Re: Linux 3.1-rc9
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111103005255.GL5971@hostway.ca>
References: <20111102191621.GF5971@hostway.ca>
	<4EB1C770.7070605@gmail.com>
	<20111103005255.GL5971@hostway.ca>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 03 Nov 2011 15:07:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Kirby <sim@hostway.ca>
Date: Wed, 2 Nov 2011 17:52:55 -0700

>> [PATCH] net: add missing bh_unlock_sock() calls
 ...
> Tested-by: Simon Kirby <sim@hostway.ca>
> 
> I tried many times, with route unreach/blackhole, and could not reproduce
> the issue with this patch applied.

Applied and queued up for -stable, thanks everyone!
