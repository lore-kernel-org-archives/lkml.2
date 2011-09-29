Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab1I2SzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 14:55:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41421 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab1I2Sy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 14:54:59 -0400
Date: Thu, 29 Sep 2011 14:54:38 -0400 (EDT)
Message-Id: <20110929.145438.1124768492738474414.davem@davemloft.net>
To: jgq516@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net/fec: replace hardcoded irq num with macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317298557-2878-1-git-send-email-jgq516@gmail.com>
References: <1317298557-2878-1-git-send-email-jgq516@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Sep 2011 11:54:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jgq516@gmail.com
Date: Thu, 29 Sep 2011 20:15:56 +0800

> From: Xiao Jiang <jgq516@gmail.com>
> 
> Don't use hardcoded irq num and replace it with
> FEC_IRQ_NUM macro.
> 
> Signed-off-by: Xiao Jiang <jgq516@gmail.com>

Applied.
