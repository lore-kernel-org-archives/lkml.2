Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1KIUjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:39:37 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38859 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1KIUjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:39:36 -0500
Date: Wed, 09 Nov 2011 15:39:27 -0500 (EST)
Message-Id: <20111109.153927.1757753106148770956.davem@davemloft.net>
To: ricardo.ribalda@gmail.com
Cc: ian.campbell@citrix.com, eric.dumazet@gmail.com,
        jeffrey.t.kirsher@intel.com, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/temac: FIX segfault when process old irqs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320744718-10916-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1320744718-10916-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 09 Nov 2011 12:39:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue,  8 Nov 2011 10:31:58 +0100

> Do not enable the irq until the scatter gather registers are ready to
> handle the data. Otherwise an irq from a packet send/received before
> last close can lead to an access to an invalid memory region on the irq
> handler.
> 
> Also, stop the dma engine on close.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Applied, thanks.
