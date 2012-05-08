Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab2EHDBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 23:01:08 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53849 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab2EHDBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 23:01:04 -0400
Date: Mon, 07 May 2012 22:58:53 -0400 (EDT)
Message-Id: <20120507.225853.1863347275703801019.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: ralf@linux-mips.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org, david.daney@cavium.com
Subject: Re: [PATCH v6 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336007799-31016-3-git-send-email-ddaney.cavm@gmail.com>
References: <1336007799-31016-1-git-send-email-ddaney.cavm@gmail.com>
	<1336007799-31016-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 07 May 2012 19:58:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Wed,  2 May 2012 18:16:38 -0700

> From: David Daney <david.daney@cavium.com>
> 
> This patch adds a somewhat generic framework for MDIO bus
> multiplexers.  It is modeled on the I2C multiplexer.
> 
> The multiplexer is needed if there are multiple PHYs with the same
> address connected to the same MDIO bus adepter, or if there is
> insufficient electrical drive capability for all the connected PHY
> devices.
> 
> Conceptually it could look something like this:
 ...
> This framework configures the bus topology from device tree data.  The
> mechanics of switching the multiplexer is left to device specific
> drivers.
> 
> The follow-on patch contains a multiplexer driven by GPIO lines.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Applied.
