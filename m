Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab2EHDBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:01:14 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53854 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab2EHDBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:01:11 -0400
Date: Mon, 07 May 2012 22:59:00 -0400 (EDT)
Message-Id: <20120507.225900.1607360124849584710.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: ralf@linux-mips.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org, david.daney@cavium.com
Subject: Re: [PATCH v6 3/3] netdev/of/phy: Add MDIO bus multiplexer driven
 by GPIO lines.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336007799-31016-4-git-send-email-ddaney.cavm@gmail.com>
References: <1336007799-31016-1-git-send-email-ddaney.cavm@gmail.com>
	<1336007799-31016-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 19:59:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Wed,  2 May 2012 18:16:39 -0700

> From: David Daney <david.daney@cavium.com>
> 
> The GPIO pins select which sub bus is connected to the master.
> 
> Initially tested with an sn74cbtlv3253 switch device wired into the
> MDIO bus.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Applied.
