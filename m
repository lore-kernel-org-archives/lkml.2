Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab1I2UdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:33:25 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49530 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab1I2UdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:33:24 -0400
Date: Thu, 29 Sep 2011 16:31:12 -0400 (EDT)
Message-Id: <20110929.163112.1523715692737597332.davem@davemloft.net>
To: david.daney@cavium.com
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] netdev/of/phy: MDIO bus multiplexer support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1317166015-20714-1-git-send-email-david.daney@cavium.com>
References: <1317166015-20714-1-git-send-email-david.daney@cavium.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Sep 2011 13:31:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>
Date: Tue, 27 Sep 2011 16:26:52 -0700

> v2: Update bindings to use "reg" and "mdio-parent-bus" insutead of
>     "cell-index" and "parent-bus"

Grant, when the final version of this patch set is ready how do
you want to handle merging it in?

I think it would be safe to merge this via your tree, since the
changes made to existing network driver files are rather trivial and
thus merge conflict friendly.

Actually, I feel like we've discussed this before :-)
