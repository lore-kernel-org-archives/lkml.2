Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1EMUMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:12:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48721 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1EMUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:12:32 -0400
Date: Fri, 13 May 2011 16:10:21 -0400 (EDT)
Message-Id: <20110513.161021.1204095204011657113.davem@davemloft.net>
To: julia@diku.dk
Cc: isdn@linux-pingi.de, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/isdn/hisax: Drop unused list
From: David Miller <davem@davemloft.net>
In-Reply-To: <1305296139-16773-1-git-send-email-julia@diku.dk>
References: <1305296139-16773-1-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 May 2011 13:10:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Fri, 13 May 2011 16:15:39 +0200

> The file st5481_init.c locally defines and initializes the adapter_list
> variable, but does not use it for anything.  Removing the list makes it
> possible to remove the list field from the st5481_adapter data structure.
> In the function probe_st5481, it also makes it possible to free the locally
> allocated adapter value on an error exit.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks a lot Julia.
