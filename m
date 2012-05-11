Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab2EKDfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:35:47 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56713 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408Ab2EKDfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:35:45 -0400
Date: Thu, 10 May 2012 23:35:41 -0400 (EDT)
Message-Id: <20120510.233541.852199665039697310.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] etherdevice.h: Add ether_addr_equal_64bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <7535e70ceb63f7da56f73cb37d4b269cd7798583.1336618708.git.joe@perches.com>
References: <cover.1336618707.git.joe@perches.com>
	<7535e70ceb63f7da56f73cb37d4b269cd7798583.1336618708.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 10 May 2012 20:35:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed,  9 May 2012 20:04:03 -0700

> Add an optimized boolean function to check if
> 2 ethernet addresses are the same.
> 
> This is to avoid any confusion about compare_ether_addr_64bits
> returning an unsigned, and not being able to use the
> compare_ether_addr_64bits function for sorting ala memcmp.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
