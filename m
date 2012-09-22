Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2IVTvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 15:51:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34867 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2IVTvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 15:51:46 -0400
Date: Sat, 22 Sep 2012 15:51:44 -0400 (EDT)
Message-Id: <20120922.155144.1725496101166891963.davem@davemloft.net>
To: stid.smth@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] pppoe: drop PPPOX_ZOMBIEs in pppoe_release
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANEcBPR8EvBTsJ0tG+kqvn578qXnqTMwdciS_WChe9sm5yKdaw@mail.gmail.com>
References: <CANEcBPR8EvBTsJ0tG+kqvn578qXnqTMwdciS_WChe9sm5yKdaw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaodong Xu <stid.smth@gmail.com>
Date: Sat, 22 Sep 2012 18:09:32 +0800

> From: Xiaodong Xu <stid.smth@gmail.com>
> 
> When PPPOE is running over a virtual ethernet interface (e.g., a
> bonding interface) and the user tries to delete the interface in case
> the PPPOE state is ZOMBIE, the kernel will loop forever while
> unregistering net_device for the reference count is not decreased to
> zero which should have been done with dev_put().
> 
> Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>

Applied and queued up for -stable, thanks.
