Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1LUTZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 14:25:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54409 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1LUTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 14:25:40 -0500
Date: Wed, 21 Dec 2011 14:23:53 -0500 (EST)
Message-Id: <20111221.142353.104409617332454885.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, tytso@mit.edu, greg@kroah.com,
        mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/7] arch, early_printk: Consolidate
 early_printk() implementations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111221111143.346150952@chello.nl>
References: <20111221105739.798864333@chello.nl>
	<20111221111143.346150952@chello.nl>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 11:23:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 21 Dec 2011 11:57:40 +0100

>  arch/sparc/kernel/setup_32.c          |    1 
>  arch/sparc/kernel/setup_64.c          |    8 ++++++-

Acked-by: David S. Miller <davem@davemloft.net>
