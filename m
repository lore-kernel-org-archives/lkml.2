Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1HKMvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:51:40 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46914 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab1HKMvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:51:37 -0400
Date: Thu, 11 Aug 2011 05:51:33 -0700 (PDT)
Message-Id: <20110811.055133.301483708516642472.davem@davemloft.net>
To: tim.c.chen@linux.intel.com
Cc: eric.dumazet@gmail.com, ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [Patch] scm: Capture the full credentials of the scm sender
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312908512.2576.97.camel@schen9-DESK>
References: <1312841316.2576.49.camel@schen9-DESK>
	<1312857834.2531.15.camel@edumazet-laptop>
	<1312908512.2576.97.camel@schen9-DESK>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 11 Aug 2011 05:51:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Chen <tim.c.chen@linux.intel.com>
Date: Tue, 09 Aug 2011 09:48:32 -0700

> This patch corrects an erroneous update of credential's gid with uid
> introduced in commit 257b5358b32f17 since 2.6.36.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Applied, thanks.
