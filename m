Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2EFRE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:04:56 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41621 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2EFREy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:04:54 -0400
Date: Sun, 06 May 2012 13:03:46 -0400 (EDT)
Message-Id: <20120506.130346.375380984480812477.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 16/18] sparc: Use common threadinfo allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120505150142.252861878@linutronix.de>
References: <20120505150007.543515803@linutronix.de>
	<20120505150142.252861878@linutronix.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 06 May 2012 10:03:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 05 May 2012 15:05:47 -0000

> Exaclty the same as the core code.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: David S. Miller <davem@davemloft.net>
