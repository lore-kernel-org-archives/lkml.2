Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2BOUl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:41:57 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60501 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2BOUlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:41:55 -0500
Date: Wed, 15 Feb 2012 15:41:40 -0500 (EST)
Message-Id: <20120215.154140.2082640267957831845.davem@davemloft.net>
To: j.weitzel@phytec.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ethernet: ks8851_mll fix irq handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329291315-7973-1-git-send-email-j.weitzel@phytec.de>
References: <1329291315-7973-1-git-send-email-j.weitzel@phytec.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 12:41:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Weitzel <j.weitzel@phytec.de>
Date: Wed, 15 Feb 2012 08:35:15 +0100

> There a two different irq variables ks->irq and netdev->irq.
> Only ks->irq is set on probe, so disabling irq in ks_start_xmit fails.
> 
> This patches remove ks->irq from private data and use only netdev->irq.
> 
> Tested on a kernel 3.0 based OMAP4430 SMP Board
> 
> Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>

Applied, thanks.
