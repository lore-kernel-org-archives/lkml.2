Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0INDLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 23:11:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38654
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752295Ab0INDLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 23:11:10 -0400
Date: Mon, 13 Sep 2010 20:11:28 -0700 (PDT)
Message-Id: <20100913.201128.233708092.davem@davemloft.net>
To: dan.j.rosenberg@gmail.com
Cc: j.dumon@option.com, linux-kernel@vger.kernel.org, security@kernel.org
Subject: Re: [PATCH] drivers/net/usb/hso.c: prevent reading uninitialized
 memory
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=RrFrYkWVHhLmyA21zNdb3KdaGXRCgLxVgZkah@mail.gmail.com>
References: <AANLkTi=RrFrYkWVHhLmyA21zNdb3KdaGXRCgLxVgZkah@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Date: Sat, 11 Sep 2010 19:46:35 -0400

> --- linux-2.6.35.4.orig/drivers/net/usb/hso.c	2010-09-11
> 19:12:00.000000000 -0400
> +++ linux-2.6.35.4/drivers/net/usb/hso.c	2010-09-11 19:15:23.000000000 -0400
> @@ -1653,6 +1653,8 @@ static int hso_get_count(struct hso_seri

All of your patches were corrupted by your email client, long lines were
broken up, and tabs were converted into spaces.

This makes your patches unusable.

Also, all networking patches should be submitted with netdev@vger.kernel.org
in the CC: list.

Please correct these issues and resubmit your patches, thank you.
