Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab2BJAIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:08:25 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60073 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758700Ab2BJAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:08:22 -0500
Date: Thu, 09 Feb 2012 19:08:15 -0500 (EST)
Message-Id: <20120209.190815.1793020340808993229.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: 8250 move broke the build on sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120209234818.GA814@windriver.com>
References: <4F344A85.4070005@windriver.com>
	<20120209.174817.1772850235758472350.davem@davemloft.net>
	<20120209234818.GA814@windriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Feb 2012 16:08:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 9 Feb 2012 18:48:19 -0500

>>From 1b0bc62a6583e319f8b764ac34f799b916656590 Mon Sep 17 00:00:00 2001
> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Thu, 9 Feb 2012 18:09:35 -0500
> Subject: [PATCH] sparc: rename drivers/tty/serial/suncore.h ->
>  include/linux/sunserialcore.h
> 
> There are multiple users of this file from different source
> paths now, and rather than have ../ paths in include statements,
> just move the file to the linux header dir.
> 
> Suggested-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David S. Miller <davem@davemloft.net>
