Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2BVT46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:56:58 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44628 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab2BVT44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:56:56 -0500
Date: Wed, 22 Feb 2012 14:56:35 -0500 (EST)
Message-Id: <20120222.145635.1104728256772204371.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dbaryshkov@gmail.com, dkukawka@suse.de, slapin@ossfans.org,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net/ieee802154/6lowpan.c: reuse eth_mac_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329914199-30862-3-git-send-email-danny.kukawka@bisect.de>
References: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
	<1329914199-30862-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 22 Feb 2012 11:56:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Wed, 22 Feb 2012 13:36:39 +0100

> Use eth_mac_addr() for .ndo_set_mac_address, remove
> lowpan_set_address since it do currently the same as
> eth_mac_addr(). Additional advantage: eth_mac_addr() already
> checks if the given address is valid
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
