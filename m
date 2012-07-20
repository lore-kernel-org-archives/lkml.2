Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2GTXS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:18:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56416 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2GTXS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:18:58 -0400
Date: Fri, 20 Jul 2012 16:18:57 -0700 (PDT)
Message-Id: <20120720.161857.613443903782303240.davem@davemloft.net>
To: yefremov.denis@gmail.com
Cc: david.decotigny@google.com, edumazet@google.com, jpirko@redhat.com,
        ian.campbell@citrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] forcedeth: spin_unlock_irq in interrupt handler fix
From: David Miller <davem@davemloft.net>
In-Reply-To: <1342821274-20623-1-git-send-email-yefremov.denis@gmail.com>
References: <1342821274-20623-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Efremov <yefremov.denis@gmail.com>
Date: Sat, 21 Jul 2012 01:54:34 +0400

> The replacement of spin_lock_irq/spin_unlock_irq pair in interrupt
> handler by spin_lock_irqsave/spin_lock_irqrestore pair.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>

Applied, thanks.
