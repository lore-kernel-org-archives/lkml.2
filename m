Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2LUD7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:59:22 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34731 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LUD7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:59:16 -0500
Date: Thu, 20 Dec 2012 19:59:15 -0800 (PST)
Message-Id: <20121220.195915.570657227615047555.davem@davemloft.net>
To: erdnetdev@gmail.com
Cc: nicolas.dichtel@6wind.com, hasko.stevo@gmail.com, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: route: fixed a coding style issues net:
 ipv4: tcp: fixed a coding style issues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1356017039.21834.2819.camel@edumazet-glaptop>
References: <1355990910-3688-1-git-send-email-hasko.stevo@gmail.com>
	<50D2FF86.3000603@6wind.com>
	<1356017039.21834.2819.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <erdnetdev@gmail.com>
Date: Thu, 20 Dec 2012 07:23:59 -0800

> Such "coding style" patches are a real pain when trying to fix bugs,
> especially dealing with stable/old kernels.

Totally agreed, and I refuse to apply such patches.
