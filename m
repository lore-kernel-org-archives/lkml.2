Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2DRRrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:47:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39860 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2DRRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:47:35 -0400
Date: Wed, 18 Apr 2012 13:45:18 -0400 (EDT)
Message-Id: <20120418.134518.381699921667230604.davem@davemloft.net>
To: david.daney@cavium.com
Cc: ddaney.cavm@gmail.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org
Subject: Re: [PATCH v4 3/3] netdev/of/phy: Add MDIO bus multiplexer driven
 by GPIO lines.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F8EEAD8.8050205@cavium.com>
References: <1334683966-12112-4-git-send-email-ddaney.cavm@gmail.com>
	<20120417.225308.1588669089502246200.davem@davemloft.net>
	<4F8EEAD8.8050205@cavium.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Apr 2012 10:45:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>
Date: Wed, 18 Apr 2012 09:24:56 -0700

> B) Regenerate the entire set with said patch rolled in?

Already regenerate patch sets with fixes incorporated into the
original patches.
