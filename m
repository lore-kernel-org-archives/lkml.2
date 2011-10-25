Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1JYJCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:02:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45785 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab1JYJCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:02:45 -0400
Date: Tue, 25 Oct 2011 05:01:13 -0400 (EDT)
Message-Id: <20111025.050113.1678938946604302787.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: sim@hostway.ca, netdev@vger.kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, davej@redhat.com,
        schwidefsky@de.ibm.com, mingo@elte.hu
Subject: Re: Linux 3.1-rc9
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwzAM6zhqCYJwoRxCdLJB+h84BDqzhF0RNQ6Jg9SQFjSA@mail.gmail.com>
References: <alpine.LFD.2.02.1110182146440.3240@ionos>
	<20111024190203.GA24410@hostway.ca>
	<CA+55aFwzAM6zhqCYJwoRxCdLJB+h84BDqzhF0RNQ6Jg9SQFjSA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 25 Oct 2011 02:01:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 09:13:48 +0200

> Added netdev, because this seems to be a generic networking bug (ABBA
> between sk_lock and icsk_retransmit_timer if my quick scan looks
> correct).
> 
> Davem?

I suspect that's all just a side effect of whatever is creating the
preempt_count imbalance.

