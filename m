Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2LCAcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 19:32:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33483 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab2LCAcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 19:32:19 -0500
Date: Sun, 02 Dec 2012 19:32:16 -0500 (EST)
Message-Id: <20121202.193216.395617646386891717.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFy1sa=D-DrWqNuvjrLW8J0Tw1+GbZhXv6VHTTTxXG_DMA@mail.gmail.com>
References: <20121128.214732.1634269294133625782.davem@davemloft.net>
	<CA+55aFy1sa=D-DrWqNuvjrLW8J0Tw1+GbZhXv6VHTTTxXG_DMA@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 2 Dec 2012 16:13:30 -0800

> David, Willy pointed me to the recent splice crash fix
> (do_tcp_sendpages and non-0-order pages). It's apparently easily
> user-triggerable.. Should I take the patch directly, or do you have a
> tree to pull. Don't want to make a release with a known oopser..

I have a tree to pull.  Coming in a few minutes.
