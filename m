Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab2EKDY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:24:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56618 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876Ab2EKDYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:24:25 -0400
Date: Thu, 10 May 2012 23:23:15 -0400 (EDT)
Message-Id: <20120510.232315.682267960099945551.davem@davemloft.net>
To: xose.vazquez@gmail.com
Cc: samuel@sortiz.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irda: irda-usb.c URL to sigmatel stir 4210/4220/4116
 fw from archive.org
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336167477-28835-1-git-send-email-xose.vazquez@gmail.com>
References: <1336167477-28835-1-git-send-email-xose.vazquez@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 20:23:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri,  4 May 2012 23:37:57 +0200

> @@ -1081,6 +1081,7 @@ static int stir421x_patch_device(struct irda_usb_cb *self)
>          /*
>           * Known firmware patch file names for STIR421x dongles
>           * are "42101001.sb" or "42101002.sb"
> +         * http://web.archive.org/web/http://www.sigmatel.com/documents/stir4210_4220_4116_patch_files.tar.gz

This really doesn't scale in the long term.

Someone needs to host this firmware at a location which serves the
needs of the people who have an interest in using this driver.
