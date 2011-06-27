Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1F0XFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:05:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38885 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab1F0XEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:04:37 -0400
Date: Mon, 27 Jun 2011 16:00:53 -0700 (PDT)
Message-Id: <20110627.160053.10231914928438213.davem@davemloft.net>
To: vitalivanov@gmail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        jkosina@suse.cz, grant.likely@secretlab.ca, eric.dumazet@gmail.com,
        tglx@linutronix.de
Subject: Re: [PATCH] treewide: fix kernel-doc warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1309192426.17574.47.camel@vivanov>
References: <1309192426.17574.47.camel@vivanov>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 27 Jun 2011 16:00:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Ivanov <vitalivanov@gmail.com>
Date: Mon, 27 Jun 2011 19:33:46 +0300

>>From 55fe3701d1ed1f1302a73cd5bfdfc7972e89f5b7 Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Mon, 27 Jun 2011 19:07:08 +0300
> Subject: [PATCH] treewide: fix kernel-doc warnings
> 
> Fix 'make htmldocs' warnings:
> 
> Warning(/include/linux/hrtimer.h:153): No description found for
> parameter 'clockid'
> Warning(/include/linux/device.h:604): Excess struct/union/enum/typedef
> member 'of_match' description in 'device'
> Warning(/include/net/sock.h:349): Excess struct/union/enum/typedef
> member 'sk_rmem_alloc' description in 'sock'
> 
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
