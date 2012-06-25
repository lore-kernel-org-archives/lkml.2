Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab2FYXuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:50:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56762 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab2FYXuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:50:52 -0400
Date: Mon, 25 Jun 2012 16:50:51 -0700 (PDT)
Message-Id: <20120625.165051.1449022290472192376.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, david.daney@cavium.com
Subject: Re: [PATCH 1/4] netdev/phy: Handle IEEE802.3 clause 45 Ethernet
 PHYs
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FE8F8D8.1050009@gmail.com>
References: <4FE8F01B.2020207@gmail.com>
	<20120625.163355.2058784474741116830.davem@davemloft.net>
	<4FE8F8D8.1050009@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Mon, 25 Jun 2012 16:48:40 -0700

> Therefore, I am going to propose that we add a 'flags' parameter to
> get_phy_device() and change the (two) callers.

Since there is only one flag, make it simply a bool for now.
