Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2JDS0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:26:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44569 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab2JDS0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:26:14 -0400
Date: Thu, 04 Oct 2012 14:26:12 -0400 (EDT)
Message-Id: <20121004.142612.1111166663063631532.davem@davemloft.net>
To: monstr@monstr.eu
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anirudh@xilinx.com,
        John.Linn@xilinx.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH 01/11] net: axienet: Remove NETIF_F_SG dropping for no
 checksum feature
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, no.

I've announced on netdev very clearly that net-next submissions are not
appropriate at this time and that only pure bug fixes should be submitted.

Watch for the announcement on netdev of net-next openning up after the
merge window closes, that's when you should resubmit this series.
