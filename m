Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1KGS1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:27:54 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43766 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1KGS1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:27:53 -0500
Date: Mon, 07 Nov 2011 13:27:44 -0500 (EST)
Message-Id: <20111107.132744.1678311240740246318.davem@davemloft.net>
To: richard@nod.at
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] wanrouter: Remove kernel_lock annotations
From: David Miller <davem@davemloft.net>
In-Reply-To: <1320654261-4473-1-git-send-email-richard@nod.at>
References: <1320654261-4473-1-git-send-email-richard@nod.at>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 Nov 2011 10:27:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>
Date: Mon,  7 Nov 2011 09:24:21 +0100

> The BKL is gone, these annotations are useless.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Applied, thanks Richard.
