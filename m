Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab2BIWsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:48:22 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59528 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab2BIWsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:48:21 -0500
Date: Thu, 09 Feb 2012 17:48:17 -0500 (EST)
Message-Id: <20120209.174817.1772850235758472350.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: 8250 move broke the build on sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F344A85.4070005@windriver.com>
References: <20120209.163009.1594369939327153054.davem@davemloft.net>
	<4F344A85.4070005@windriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 09 Feb 2012 14:48:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 9 Feb 2012 17:36:53 -0500

> It only uses suncore.h for sunserial_register_minors (and unreg).
> Would you like it better if I killed all ifdefs and the include
> and used an incantation of weak instead?  Might be cleaner....

It's the "../" that's ugly, not the include and usage itself.

If it's now going to be included from multiple dirs, we should
probably move it to include/linux/sunserialcore.h or similar.
