Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2CEVvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:51:13 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2CEVvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:51:11 -0500
Date: Mon, 05 Mar 2012 16:51:05 -0500 (EST)
Message-Id: <20120305.165105.1278606832898736557.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: jitendra.kalsaria@qlogic.com, ron.mercer@qlogic.com,
        linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] qla3xxx: ethernet: Fix bogus interrupt state flag.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1330700945-18195-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 05 Mar 2012 13:51:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh nayak <santoshprasadnayak@gmail.com>
Date: Fri,  2 Mar 2012 20:39:05 +0530

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> In 'ql_adapter_initialize'
> the first call for 'spin_unlock_irqrestore()' is with hw_flags = 0,
> which is as good as 'spin_unlock_irq()' (unconditional interrupt
> enabling). If this is intended, then for better performance
> 'spin_unlock_irqrestore()' can be replaced with 'spin_unlock_irq()'
> and 'spin_lock_irqsave()' can be replaced by 'spin_lock_irq()
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

This change is definitely correct, applied, thanks.
