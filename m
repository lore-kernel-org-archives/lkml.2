Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2HWCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:16:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60147 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab2HWCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:16:55 -0400
Date: Wed, 22 Aug 2012 19:16:54 -0700 (PDT)
Message-Id: <20120822.191654.1727215659090597701.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.daney@cavium.com
Subject: Re: [PATCH 0/8] netdev/MIPS: Improvements to octeon_mgmt Ethernet
 driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1345574712-21444-1-git-send-email-ddaney.cavm@gmail.com>
References: <1345574712-21444-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Tue, 21 Aug 2012 11:45:04 -0700

> From: David Daney <david.daney@cavium.com>
> 
> Recent additions to the OCTEON SoC family have included enhancements
> to the MIX (octeon_mgmt) Ethernet hardware.  These include:
> 
> o 1Gig support (up from 100M).
> 
> o Hardware timestamping for PTP.
> 
> Here we add support for these two features as well as some ethtool
> improvements and cleanup of the MAC address handling.
> 
> Patch 1/8 is a prerequisite for the rest, and lives in the MIPS
> architecture part of the tree.  Since octeon_mgmt devices are only
> found in OCTEON SoCs we could merge the whole set via Ralf's tree, or
> get Ralf to affix his Acked-by and have it go via the netdev tree.

You can send this all via the MIPS tree, and feel free to add my:

Acked-by: David S. Miller <davem@davemloft.net>
