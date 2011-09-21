Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1IURl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:41:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48728 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1IURlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:41:24 -0400
Date: Wed, 21 Sep 2011 13:40:07 -0400 (EDT)
Message-Id: <20110921.134007.1812828154454173068.davem@davemloft.net>
To: yong.zhang0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, joe@perches.com, paul.gortmaker@windriver.com,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 18/57] sparc: irq: Remove IRQF_DISABLED
From: David Miller <davem@davemloft.net>
In-Reply-To: <1316597339-29861-19-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
	<1316597339-29861-19-git-send-email-yong.zhang0@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Sep 2011 10:40:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Date: Wed, 21 Sep 2011 17:28:19 +0800

> Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
> We run all interrupt handlers with interrupts disabled
> and we even check and yell when an interrupt handler
> returns with interrupts enabled (see commit [b738a50a:
> genirq: Warn when handler enables interrupts]).
> 
> So now this flag is a NOOP and can be removed.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
