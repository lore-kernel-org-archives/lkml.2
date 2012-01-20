Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2ATSrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:47:01 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60974 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2ATSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:46:58 -0500
Date: Fri, 20 Jan 2012 13:46:52 -0500 (EST)
Message-Id: <20120120.134652.1449418393129426502.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] [trivial] sctp : Fix typo in net/sctp/socket.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1327072786-3134-1-git-send-email-standby24x7@gmail.com>
References: <1327072786-3134-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 20 Jan 2012 10:46:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Sat, 21 Jan 2012 00:19:46 +0900

> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> 
> Correct a typo "sctp_setsocktopt_bindx" to "sctp_setsockopt_bindx"
> in net/sctp/socket.c

There is no such list named "linux-netdev" it's just plain "netdev"

Please fully resubmit this patch with the list name corrected, thank
you.
