Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab1HDLyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:54:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40593 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1HDLyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:54:21 -0400
Date: Thu, 04 Aug 2011 04:51:54 -0700 (PDT)
Message-Id: <20110804.045154.1306142356696424866.davem@davemloft.net>
To: davidb@codeaurora.org
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2] of/address: Add of_iomap_nocache
From: David Miller <davem@davemloft.net>
In-Reply-To: <1312454196-31028-1-git-send-email-davidb@codeaurora.org>
References: <1312451629-28036-1-git-send-email-davidb@codeaurora.org>
	<1312454196-31028-1-git-send-email-davidb@codeaurora.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 04:51:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brown <davidb@codeaurora.org>
Date: Thu,  4 Aug 2011 03:36:36 -0700

> Add uncached mappings from devicetree nodes similar to regular io
> mappings.
> 
> SPARC is coherent, so there this call is the same as regular of_iomap.
> 
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: David Brown <davidb@codeaurora.org>

Acked-by: David S. Miller <davem@davemloft.net>
