Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2BMVCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:02:47 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38138 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148Ab2BMVCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:02:45 -0500
Date: Mon, 13 Feb 2012 16:02:40 -0500 (EST)
Message-Id: <20120213.160240.316262527803124385.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, jackm@dev.mellanox.co.il,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mlx4: Fix kcalloc parameters swapped
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329095679.3066.1.camel@phoenix>
References: <1329095679.3066.1.camel@phoenix>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 13 Feb 2012 13:02:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 13 Feb 2012 09:14:39 +0800

> The first parameter should be "number of elements" and the second parameter
> should be "element size".
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.
