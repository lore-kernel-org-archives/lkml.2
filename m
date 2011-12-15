Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab1LORCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:02:09 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:42332 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759164Ab1LORCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:02:07 -0500
Date: Thu, 15 Dec 2011 11:59:56 -0500 (EST)
Message-Id: <20111215.115956.1226008158424194374.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        eric.dumazet@gmail.com, sfr@canb.auug.org.au
Subject: Re: [PATCH 1/2] Move limit definitions outside CONFIG_INET
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323941672-14324-2-git-send-email-glommer@parallels.com>
References: <1323941672-14324-1-git-send-email-glommer@parallels.com>
	<1323941672-14324-2-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Dec 2011 08:59:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Thu, 15 Dec 2011 13:34:31 +0400

> They need to be available for other protocols as well, since
> they are used in sock.c openly
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Applied.
