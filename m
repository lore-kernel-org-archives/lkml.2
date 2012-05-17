Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030440Ab2EQWYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:24:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35623 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030442Ab2EQWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:24:14 -0400
Date: Thu, 17 May 2012 18:23:27 -0400 (EDT)
Message-Id: <20120517.182327.996399544318392752.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/net: delete all code/drivers depending on
 CONFIG_MCA
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120517212039.GC27789@windriver.com>
References: <1337272841-25931-3-git-send-email-paul.gortmaker@windriver.com>
	<4FB52C99.6010303@windriver.com>
	<20120517212039.GC27789@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 May 2012 15:24:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 17 May 2012 17:20:39 -0400

> I've layered the above commit (with 3c527.h deleted) onto today's
> net-next, did a quick re-test of x86_64 allmodconfig and put it
> on a branch as per below (vs sending a 5000+ line patch).
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git delete-mca-net-drivers

Pulled, thanks Paul.
