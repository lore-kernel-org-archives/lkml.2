Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1KHTDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:03:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59402 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab1KHTDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:03:16 -0500
Date: Tue, 08 Nov 2011 14:03:12 -0500 (EST)
Message-Id: <20111108.140312.2104080830131697151.davem@davemloft.net>
To: kinwin2008@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Fix comments for Nagle algorithm
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320503003-5169-1-git-send-email-kinwin2008@gmail.com>
References: <1320503003-5169-1-git-send-email-kinwin2008@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Nov 2011 11:03:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng King <kinwin2008@gmail.com>
Date: Sat,  5 Nov 2011 22:23:23 +0800

> TCP_NODELAY is weaker than TCP_CORK, when TCP_CORK was set, small
> segments will always pass Nagle test regardless of TCP_NODELAY option.
> 
> Signed-off-by: Feng King <kinwin2008@gmail.com>

Applied, thanks.
