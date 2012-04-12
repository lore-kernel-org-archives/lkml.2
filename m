Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934656Ab2DLTqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:46:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40816 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab2DLTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:46:45 -0400
Date: Thu, 12 Apr 2012 15:46:17 -0400 (EDT)
Message-Id: <20120412.154617.1852535448842801656.davem@davemloft.net>
To: msink@permonline.ru
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: Remove CONFIG_WIZNET_TX_FLOW option
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334211288-7682-1-git-send-email-msink@permonline.ru>
References: <1334211288-7682-1-git-send-email-msink@permonline.ru>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 12:46:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Sinkovsky <msink@permonline.ru>
Date: Thu, 12 Apr 2012 12:14:48 +0600

> This option was there for debugging race conditions,
> just remove it, and assume TX_FLOW is always enabled.
> 
> Signed-off-by: Mike Sinkovsky <msink@permonline.ru>

Applied.
