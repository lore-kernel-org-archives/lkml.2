Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab2HPWMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:12:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35942 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab2HPWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:11:57 -0400
Date: Thu, 16 Aug 2012 15:11:56 -0700 (PDT)
Message-Id: <20120816.151156.967092597887492349.davem@davemloft.net>
To: john.r.fastabend@intel.com
Cc: viro@ZenIV.linux.org.uk, nhorman@tuxdriver.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v3 3/3] net: netprio: fix cgrp create and write
 priomap race
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120814223435.3551.62387.stgit@jf-dev1-dcblab>
References: <20120814223424.3551.21608.stgit@jf-dev1-dcblab>
	<20120814223435.3551.62387.stgit@jf-dev1-dcblab>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Fastabend <john.r.fastabend@intel.com>
Date: Tue, 14 Aug 2012 15:34:35 -0700

> A race exists where creating cgroups and also updating the priomap
> may result in losing a priomap update. This is because priomap
> writers are not protected by rtnl_lock.
> 
> Move priority writer into rtnl_lock()/rtnl_unlock().
> 
> CC: Neil Horman <nhorman@tuxdriver.com>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>

Applied.
