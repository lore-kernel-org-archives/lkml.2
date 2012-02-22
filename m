Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2BVU1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:27:48 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44851 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab2BVU1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:27:46 -0500
Date: Wed, 22 Feb 2012 15:26:26 -0500 (EST)
Message-Id: <20120222.152626.1290364413773909040.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: mroos@linux.ee, tj@kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F45326C.3000408@oldelvet.org.uk>
References: <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com>
	<alpine.SOC.1.00.1202220213180.4171@math.ut.ee>
	<4F45326C.3000408@oldelvet.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 22 Feb 2012 12:26:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Mortimer <richm@oldelvet.org.uk>
Date: Wed, 22 Feb 2012 18:22:36 +0000

> memblock reserved: ADD [0x0000007fcc0a40-0x0000007fcc0a4e] node 1
> memblock reserved: add [0x0000007fcc0a40-000000007fcc0a4e] node 1 @767

These are physical addresses.

> But a similar address in the registers has fffff800 in there.
> 
> o4: fffff8007fcc0a4d

All of physical memory is mapped linearly starting at 0xfffff80000000000
and this is such a virtual address.
