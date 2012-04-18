Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2DRCzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:55:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33062 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2DRCzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:55:24 -0400
Date: Tue, 17 Apr 2012 22:53:08 -0400 (EDT)
Message-Id: <20120417.225308.1588669089502246200.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org, david.daney@cavium.com
Subject: Re: [PATCH v4 3/3] netdev/of/phy: Add MDIO bus multiplexer driven
 by GPIO lines.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334683966-12112-4-git-send-email-ddaney.cavm@gmail.com>
References: <1334683966-12112-1-git-send-email-ddaney.cavm@gmail.com>
	<1334683966-12112-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Apr 2012 19:53:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney.cavm@gmail.com>
Date: Tue, 17 Apr 2012 10:32:46 -0700

> From: David Daney <david.daney@cavium.com>
> 
> The GPIO pins select which sub bus is connected to the master.
> 
> Initially tested with an sn74cbtlv3253 switch device wired into the
> MDIO bus.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Are you sure the Kconfig dependencies are sufficient?  This code seems
to depend upon OF, and in particular the OF_MDIO stuff.
