Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2D3QwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:52:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab2D3QwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:52:13 -0400
Date: Mon, 30 Apr 2012 12:49:56 -0400 (EDT)
Message-Id: <20120430.124956.549873851265050903.davem@davemloft.net>
To: glommer@parallels.com
Cc: eric.dumazet@gmail.com, denys@visp.net.lb, netdev@vger.kernel.org,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        linux-kernel@vger.kernel.org
Subject: Re: inconsistent lock/deadlock crash, vanilla 3.3.4, 32bit, tcp
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F9E18E9.5010503@parallels.com>
References: <1335688804.2900.83.camel@edumazet-glaptop>
	<1335689052.2900.86.camel@edumazet-glaptop>
	<4F9E18E9.5010503@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 30 Apr 2012 09:50:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Mon, 30 Apr 2012 01:45:29 -0300

> It wasn't my intent to change that, it was a mistake.

I very much regret succumbing to the unreasonable pressure to apply
your original patches.

We've come to learn that they were full of errors and that they needed
to cook for several more months before being included.
