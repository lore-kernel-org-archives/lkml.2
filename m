Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1LMSr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:47:29 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49749 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LMSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:47:27 -0500
Date: Tue, 13 Dec 2011 13:45:44 -0500 (EST)
Message-Id: <20111213.134544.897666694310425225.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: christoph.paasch@uclouvain.be, glommer@parallels.com,
        linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        gthelen@google.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name, avagin@parallels.com, devel@openvz.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH v9 0/9] Request for inclusion: per-cgroup tcp memory
 pressure controls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323784748.2950.4.camel@edumazet-laptop>
References: <20111212.190734.1967808916779299221.davem@davemloft.net>
	<4EE757D7.6060006@uclouvain.be>
	<1323784748.2950.4.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 13 Dec 2011 10:45:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 13 Dec 2011 14:59:08 +0100

> [PATCH net-next] net: fix build error if CONFIG_CGROUPS=n
> 
> Reported-by: Christoph Paasch <christoph.paasch@uclouvain.be>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks.
