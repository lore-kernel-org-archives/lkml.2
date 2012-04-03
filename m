Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2DCVuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 17:50:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38636 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2DCVuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 17:50:23 -0400
Date: Tue, 03 Apr 2012 17:48:14 -0400 (EDT)
Message-Id: <20120403.174814.1643372599291158711.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH v3,1/1] net/hyperv: Add flow control based on hi/low
 watermark
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332890445-12562-2-git-send-email-haiyangz@microsoft.com>
References: <1332890445-12562-1-git-send-email-haiyangz@microsoft.com>
	<1332890445-12562-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 14:48:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 27 Mar 2012 16:20:45 -0700

> In the existing code, we only stop queue when the ringbuffer is full,
> so the current packet has to be dropped or retried from upper layer.
> 
> This patch stops the tx queue when available ringbuffer is below
> the low watermark. So the ringbuffer still has small amount of space
> available for the current packet. This will reduce the overhead of
> retries on sending.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Applied to net-next
