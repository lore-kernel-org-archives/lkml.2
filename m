Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1HDIaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:30:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35217 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1HDIat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:30:49 -0400
Date: Thu, 04 Aug 2011 01:30:45 -0700 (PDT)
Message-Id: <20110804.013045.68180626611349178.davem@davemloft.net>
To: julia@diku.dk
Cc: kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers/ide/cy82c693.c: Add missing pci_dev_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311870407-22461-2-git-send-email-julia@diku.dk>
References: <1311870407-22461-2-git-send-email-julia@diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 01:30:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Thu, 28 Jul 2011 18:26:47 +0200

> From: Julia Lawall <julia@diku.dk>
> 
> Pci_get_slot calls pci_dev_get, so pci_dev_put is needed before leaving the
> function in the case where pci_get_slot is locally used.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks!
