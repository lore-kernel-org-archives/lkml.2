Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2DUTeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 15:34:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43427 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2DUTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 15:34:17 -0400
Date: Sat, 21 Apr 2012 15:32:01 -0400 (EDT)
Message-Id: <20120421.153201.2103447307695063734.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org, david.daney@cavium.com
Subject: Re: [PATCH v5 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334791254-15987-3-git-send-email-ddaney.cavm@gmail.com>
References: <1334791254-15987-1-git-send-email-ddaney.cavm@gmail.com>
	<1334791254-15987-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 21 Apr 2012 12:32:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Wed, 18 Apr 2012 16:20:53 -0700

> +config MDIO_BUS_MUX
> +	tristate
> +	help
> +	  This module provides a driver framework for MDIO bus
> +	  multiplexers which connect one of several child MDIO busses
> +	  to a parent bus.  Switching between child busses is done by
> +	  device specific drivers.
> +

This driver uses OF and OF_MDIO, and therefore need dependencies upon
them.  Otherwise it can be enabled in configurations which will result
in build failures.
