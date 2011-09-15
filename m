Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650Ab1IOToL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:44:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41372 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:44:09 -0400
Date: Thu, 15 Sep 2011 15:43:57 -0400 (EDT)
Message-Id: <20110915.154357.1768237553617962596.davem@davemloft.net>
To: ying.huang@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rds-devel@oss.oracle.com, netdev@vger.kernel.org,
        chris.mason@oracle.com, andy.grover@oracle.com
Subject: Re: [PATCH -mm RESEND] net, rds, Replace xlist in net/rds/xlist.h
 with llist
From: David Miller <davem@davemloft.net>
In-Reply-To: <1314753690-31250-1-git-send-email-ying.huang@intel.com>
References: <1314753690-31250-1-git-send-email-ying.huang@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 15 Sep 2011 12:44:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Date: Wed, 31 Aug 2011 09:21:30 +0800

> The functionality of xlist and llist is almost same.  This patch
> replace xlist with llist to avoid code duplication.
> 
> Known issues: don't know how to test this, need special hardware?
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Applied.
