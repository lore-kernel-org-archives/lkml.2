Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1KPWAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:00:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57603 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1KPWAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:00:02 -0500
Date: Wed, 16 Nov 2011 16:58:35 -0500 (EST)
Message-Id: <20111116.165835.803145377567644412.davem@davemloft.net>
To: sim@hostway.ca
Cc: eric.dumazet@gmail.com, tglx@linutronix.de, netdev@vger.kernel.org,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, davej@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu
Subject: Re: [3.1] Divide by zero in __tcp_select_window()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111116195419.GE24411@hostway.ca>
References: <20111114.153608.2064552703690099046.davem@davemloft.net>
	<1321304216.2719.23.camel@edumazet-laptop>
	<20111116195419.GE24411@hostway.ca>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 16 Nov 2011 13:58:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Kirby <sim@hostway.ca>
Date: Wed, 16 Nov 2011 11:54:19 -0800

> Looks good, thanks! Working on ~25 boxes without issue for >36 hours.
> 
> Simon-
> 
> Tested-by: Simon Kirby <sim@hostway.ca>
> 
>> [PATCH] tcp: clear xmit timers in tcp_v4_syn_recv_sock()

Applied and queued up for -stable, thanks everyone.
