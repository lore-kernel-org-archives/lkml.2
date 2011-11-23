Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1KWVkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:40:49 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:39123 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab1KWVks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:40:48 -0500
Date: Wed, 23 Nov 2011 16:40:44 -0500 (EST)
Message-Id: <20111123.164044.1368395311869170507.davem@davemloft.net>
To: LKML@hover.be
Cc: peter.p.waskiewicz.jr@intel.com, zambrano@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] b44.c Use dev_kfree_skb_irq() in b44_tx()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1322056588-26171-1-git-send-email-LKML@hover.be>
References: <Re:_softirq_oops_from_b44_poll>
	<1322056588-26171-1-git-send-email-LKML@hover.be>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 23 Nov 2011 13:40:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xander Hover <LKML@hover.be>
Date: Wed, 23 Nov 2011 14:56:28 +0100

> Reported issues when using dev_kfree_skb() on UP systems and
> systems with low numbers of cores.  dev_kfree_skb_irq() will
> properly save IRQ state before freeing the skb.
> 
> Tested on 3.1.1 and 3.2_rc2
 ...
> Signed-off-by: Xander Hover <LKML@hover.be>

Applied, thanks.
