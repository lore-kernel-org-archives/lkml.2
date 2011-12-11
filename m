Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab1LKUDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:03:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:57864 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1LKUDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:03:46 -0500
Date: Sun, 11 Dec 2011 15:02:40 -0500 (EST)
Message-Id: <20111211.150240.2083787980841719527.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wirelss 2011-12-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111209192228.GC14236@tuxdriver.com>
References: <20111209192228.GC14236@tuxdriver.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 11 Dec 2011 12:02:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 9 Dec 2011 14:22:28 -0500

> This is a collection of fixes intended for 3.2.
> 
> Gustavo describes the Blueooth bits thusly: "Some fixes for 3.2:
> support for a new Marvell device, two module reference fixes, a memory
> leak fix and finally a check in a HCI version check."
> 
> Additionally, we have an ath9k fix for a regression on single-stream
> chips, a mac80211 fix for a race in aggregation start (looks big due
> to moving some functions to avoid forward declarations), a fix for
> some improper power state management in the rtlwifi suite, and a fix
> for an ssb init regression on some SoCs.
> 
> Please let me know if there are problems!

Pulled, thanks John.

As we wind down towards the end of these RCs, please exert even
more pushback on bug fixes from now until 3.2 goes out.

Thanks.
