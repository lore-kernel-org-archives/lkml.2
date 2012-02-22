Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2BVT5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:57:42 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44644 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab2BVT5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:57:41 -0500
Date: Wed, 22 Feb 2012 14:56:29 -0500 (EST)
Message-Id: <20120222.145629.697083360270812669.davem@davemloft.net>
To: danny.kukawka@bisect.de
Cc: dave@thedillows.org, dkukawka@suse.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] 3com/typhoon: reuse eth_mac_addr()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329914199-30862-2-git-send-email-danny.kukawka@bisect.de>
References: <1329914199-30862-1-git-send-email-danny.kukawka@bisect.de>
	<1329914199-30862-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 22 Feb 2012 11:56:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <danny.kukawka@bisect.de>
Date: Wed, 22 Feb 2012 13:36:38 +0100

> Use eth_mac_addr() for .ndo_set_mac_address, remove
> typhoon_set_mac_address() since it do currently the same as
> eth_mac_addr(). Additional advantage: eth_mac_addr() already
> checks if the given address is valid.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied.
