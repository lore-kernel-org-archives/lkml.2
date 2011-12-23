Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1LWDjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 22:39:44 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:40343 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1LWDjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 22:39:42 -0500
Date: Thu, 22 Dec 2011 22:39:23 -0500 (EST)
Message-Id: <20111222.223923.800285938031564380.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        cgroups@vger.kernel.org, kirill@shutemov.name, paul@paulmenage.org,
        gthelen@google.com, jweiner@redhat.com
Subject: Re: [PATCH v2] Partial revert "Basic kernel memory functionality
 for the Memory Controller"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324551747-5925-1-git-send-email-glommer@parallels.com>
References: <1324551747-5925-1-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 22 Dec 2011 19:39:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Thu, 22 Dec 2011 15:02:27 +0400

> This reverts commit e5671dfae59b165e2adfd4dfbdeab11ac8db5bda.
> 
> After a follow up discussion with Michal, it was agreed it would
> be better to leave the kmem controller with just the tcp files,
> deferring the behavior of the other general memory.kmem.* files
> for a later time, when more caches are controlled. This is because
> generic kmem files are not used by tcp accounting and it is
> not clear how other slab caches would fit into the scheme.
> 
> We are reverting the original commit so we can track the reference.
> Part of the patch is kept, because it was used by the later tcp
> code. Conflicts are shown in the bottom. init/Kconfig is removed from
> the revert entirely.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Applied.
