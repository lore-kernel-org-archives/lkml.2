Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2BOVo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 16:44:56 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:32795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2BOVoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 16:44:55 -0500
Date: Wed, 15 Feb 2012 16:42:45 -0500 (EST)
Message-Id: <20120215.164245.2208394038607502286.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH] of: Only compile OF_DYNAMIC on PowerPC pseries and
 iseries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1329240330-3539-1-git-send-email-grant.likely@secretlab.ca>
References: <1329240330-3539-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 15 Feb 2012 13:42:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 14 Feb 2012 10:25:30 -0700

> Only two architectures use the OF node reference counting and reclaim bits.
> There is no need to compile it for the rest of the PowerPC platforms or for
> any of the other architectures.  This patch makes iseries and pseries
> select CONFIG_OF_DYNAMIC, and makes it default to off for everything else.
> 
> It is still safe to turn on CONFIG_OF_DYNAMIC on all architectures, it just
> isn't necessary.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
