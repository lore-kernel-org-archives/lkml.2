Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1HDKPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:15:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60255 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1HDKPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:15:02 -0400
Date: Thu, 04 Aug 2011 03:12:54 -0700 (PDT)
Message-Id: <20110804.031254.836213129500890372.davem@davemloft.net>
To: davidb@codeaurora.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] of/address: Add of_iomap_nocache
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312451629-28036-1-git-send-email-davidb@codeaurora.org>
References: <1312451629-28036-1-git-send-email-davidb@codeaurora.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 03:12:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brown <davidb@codeaurora.org>
Date: Thu,  4 Aug 2011 02:53:49 -0700

> Add uncached mappings from devicetree nodes similar to regular io
> mappings.
> 
> Signed-off-by: David Brown <davidb@codeaurora.org>

You'll need to add a sparc implementation.
