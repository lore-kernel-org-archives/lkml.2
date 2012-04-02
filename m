Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2DBDKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 23:10:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47025 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab2DBDKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:10:19 -0400
Date: Sun, 01 Apr 2012 23:07:43 -0400 (EDT)
Message-Id: <20120401.230743.1997120747469287815.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] net/ipv6/icmp.c: Checkpatch cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333302548-9187-7-git-send-email-eldad@fogrefinery.com>
References: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
	<1333302548-9187-7-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 20:07:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sun,  1 Apr 2012 19:49:07 +0200

> icmp.c:501: ERROR: "(foo*)" should be "(foo *)"
> icmp.c:582: ERROR: "(foo*)" should be "(foo *)"
> icmp.c:954: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Applied.
