Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1JYXT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 19:19:58 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41811 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1JYXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 19:19:57 -0400
Date: Tue, 25 Oct 2011 19:18:19 -0400 (EDT)
Message-Id: <20111025.191819.1527543903045617185.davem@davemloft.net>
To: tglx@linutronix.de
Cc: torvalds@linux-foundation.org, sim@hostway.ca, netdev@vger.kernel.org,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, davej@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu
Subject: Re: Linux 3.1-rc9
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.02.1110251419170.21837@ionos>
References: <CA+55aFwzAM6zhqCYJwoRxCdLJB+h84BDqzhF0RNQ6Jg9SQFjSA@mail.gmail.com>
	<20111025.050113.1678938946604302787.davem@davemloft.net>
	<alpine.LFD.2.02.1110251419170.21837@ionos>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 25 Oct 2011 16:18:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 25 Oct 2011 14:30:50 +0200 (CEST)

> Subject: net: Unlock sock before calling sk_free()
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Good spotting, applied, thanks Thomas!
