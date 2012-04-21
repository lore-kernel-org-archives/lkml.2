Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2DUXFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 19:05:55 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44425 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2DUXFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 19:05:54 -0400
Date: Sat, 21 Apr 2012 19:03:35 -0400 (EDT)
Message-Id: <20120421.190335.1197591560590885057.davem@davemloft.net>
To: david.s.daney@gmail.com
Cc: ddaney.cavm@gmail.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org, david.daney@cavium.com
Subject: Re: [PATCH v5 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F9325DF.7020003@gmail.com>
References: <1334791254-15987-3-git-send-email-ddaney.cavm@gmail.com>
	<20120421.153201.2103447307695063734.davem@davemloft.net>
	<4F9325DF.7020003@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 21 Apr 2012 16:03:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.s.daney@gmail.com>
Date: Sat, 21 Apr 2012 14:25:51 -0700

> If we were to specify the dependencies in both places, we gain nothing
> other than duplication of information.

Each Kconfig option enabling a module has to have appropriate
dependencies.
