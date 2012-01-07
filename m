Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2AGSRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 13:17:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49897 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2AGSRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 13:17:12 -0500
Date: Sat, 07 Jan 2012 10:17:02 -0800 (PST)
Message-Id: <20120107.101702.971636020211532236.davem@davemloft.net>
To: glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cgroups@vger.kernel.org, gthelen@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, chavey@google.com
Subject: Re: [PATCH] net: fix sock_clone reference mismatch with tcp
 memcontrol
From: David Miller <davem@davemloft.net>
In-Reply-To: <1325830599-11857-1-git-send-email-glommer@parallels.com>
References: <1325830599-11857-1-git-send-email-glommer@parallels.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 07 Jan 2012 10:17:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@parallels.com>
Date: Fri,  6 Jan 2012 10:16:39 +0400

> Sockets can also be created through sock_clone. Because it copies
> all data in the sock structure, it also copies the memcg-related pointer,
> and all should be fine. However, since we now use reference counts in
> socket creation, we are left with some sockets that have no reference
> counts. It matters when we destroy them, since it leads to a mismatch.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>

Applied, thanks.
