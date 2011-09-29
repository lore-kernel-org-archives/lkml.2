Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1I2EeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 00:34:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:46287 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab1I2EeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 00:34:06 -0400
Date: Thu, 29 Sep 2011 00:34:02 -0400 (EDT)
Message-Id: <20110929.003402.1451668842764449391.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dm@chelsio.com,
        swise@opengridcomputing.com, kxie@chelsio.com
Subject: Re: [PATCH net-2.6] cxgb4: Fix EEH on IBM P7IOC
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110924161130.18521.39558.stgit@speedy5.asicdesigners.com>
References: <20110924161130.18521.39558.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Sep 2011 21:34:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Sat, 24 Sep 2011 09:11:31 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Fix EEH recovery on new P Series platform by
> requesting fundamental reset.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
