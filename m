Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1LMAIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:08:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41485 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1LMAH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:07:57 -0500
Date: Mon, 12 Dec 2011 19:07:34 -0500 (EST)
Message-Id: <20111212.190734.1967808916779299221.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        gthelen@google.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name, avagin@parallels.com, devel@openvz.org,
        eric.dumazet@gmail.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 0/9] Request for inclusion: per-cgroup tcp memory
 pressure controls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323676029-5890-1-git-send-email-glommer@parallels.com>
References: <1323676029-5890-1-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Dec 2011 16:07:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Mon, 12 Dec 2011 11:47:00 +0400

> This series fixes all the few comments raised in the last round,
> and seem to have acquired consensus from the memcg side.
> 
> Dave, do you think it is acceptable now from the networking PoV?
> In case positive, would you prefer merging this trough your tree,
> or acking this so a cgroup maintainer can do it?

All applied to net-next, thanks.
