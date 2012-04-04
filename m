Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2DDWHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:07:20 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50312 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab2DDWHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:07:18 -0400
Date: Wed, 04 Apr 2012 18:07:06 -0400 (EDT)
Message-Id: <20120404.180706.345415198105146886.davem@davemloft.net>
To: LinoSanfilippo@gmx.de
Cc: shemminger@vyatta.com, mlindner@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: sky2: in free_buffers() do proper checks before call of
 rx_clean()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120403001327.GB10227@Neptun>
References: <20120403001327.GB10227@Neptun>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 15:07:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Date: Tue, 3 Apr 2012 02:13:27 +0200

> In sky2_open() free_buffers() is called in case that alloc_buffers() failed.
> Here we do the check for sky2->rx_le too late, since we already called
> rx_clean() which accessed rx_le. Furthermore we lack a check for sky2->rx_ring
> which is also accessed by rx_clean().
> 
> With this patch both sky2->rx_le and sky2->rx_ring are checked before
> alloc_buffers() is called.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Ping?
