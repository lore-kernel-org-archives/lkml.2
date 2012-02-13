Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2BMFvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:51:32 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:59212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab2BMFvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:51:24 -0500
Date: Mon, 13 Feb 2012 00:50:03 -0500 (EST)
Message-Id: <20120213.005003.188848469193975189.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dkukawka@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com, eric.dumazet@gmail.com, rdunlap@xenotime.net
Subject: Re: [PATCH v2 1/2] eth: reset addr_assign_type if eth_mac_addr()
 called
From: David Miller <davem@davemloft.net>
In-Reply-To: <1328816934-11508-2-git-send-email-danny.kukawka@bisect.de>
References: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
	<1328816934-11508-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 12 Feb 2012 21:50:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Thu,  9 Feb 2012 20:48:53 +0100

> If eth_mac_addr() get called, usually if SIOCSIFHWADDR was
> used to change the MAC of a ethernet device, reset the
> addr_assign_type to NET_ADDR_PERM if the state was
> NET_ADDR_RANDOM before. Reset the state since the MAC is
> no longer random at least not from the kernel side.
> 
> v2: changed to bitops, removed if()
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
