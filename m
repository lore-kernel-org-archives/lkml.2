Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab1LUUrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:47:19 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55144 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1LUUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:47:17 -0500
Date: Wed, 21 Dec 2011 15:43:02 -0500 (EST)
Message-Id: <20111221.154302.206106800367957142.davem@davemloft.net>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        grant.likely@secretlab.ca, rmallon@gmail.com
Subject: Re: [PATCH 2/4] net: ethernet: xilinx: Don't use NO_IRQ in xilinx
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324477932-19262-2-git-send-email-monstr@monstr.eu>
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
	<1324477932-19262-2-git-send-email-monstr@monstr.eu>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 12:43:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>
Date: Wed, 21 Dec 2011 15:32:10 +0100

> Fix ll_temac and emaclite drivers. Only Microblaze and Xilinx PPC
> use then and both use NO_IRQ as 0. It will be removed in near future.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Applied, thanks.
