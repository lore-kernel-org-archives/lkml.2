Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1LFTAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:00:35 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60638 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1LFTAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:00:34 -0500
Date: Tue, 06 Dec 2011 14:00:09 -0500 (EST)
Message-Id: <20111206.140009.2069228986419257738.davem@davemloft.net>
To: sboyd@codeaurora.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCHv2] net: Silence seq_scale() unused warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1323194680-32127-1-git-send-email-sboyd@codeaurora.org>
References: <20111206.003157.159978113328078893.davem@davemloft.net>
	<1323194680-32127-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 06 Dec 2011 11:00:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>
Date: Tue,  6 Dec 2011 10:04:40 -0800

> On a CONFIG_NET=y build
> 
> net/core/secure_seq.c:22: warning: 'seq_scale' defined but not
> used
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied, thanks.
