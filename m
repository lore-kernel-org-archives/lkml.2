Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977Ab1GBELq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 00:11:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51045 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1GBELp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 00:11:45 -0400
Date: Fri, 01 Jul 2011 21:11:25 -0700 (PDT)
Message-Id: <20110701.211125.1336236217021544514.davem@davemloft.net>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch 11/11] sparc/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110702033854.600969289@goodmis.org>
References: <20110702030435.308336775@goodmis.org>
	<20110702033854.600969289@goodmis.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 01 Jul 2011 21:11:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 01 Jul 2011 23:04:46 -0400

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> Although they are marked inline, gcc may still make a function out of
> them and add it to the pool of functions that are traced by the function
> tracer. This can cause undesirable results (kernel panic, triple faults,
> etc).
> 
> Add the notrace notation to prevent them from ever being traced.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: David S. Miller <davem@davemloft.net>
