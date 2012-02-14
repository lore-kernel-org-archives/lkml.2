Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2BNFyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 00:54:25 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:56200 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2BNFyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 00:54:21 -0500
Date: Tue, 14 Feb 2012 07:54:18 +0200 (EET)
From: mroos@linux.ee
To: David Miller <davem@davemloft.net>
cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120213.195835.1573147101037168145.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1202140750130.1759@math.ut.ee>
References: <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca> <20120213.195835.1573147101037168145.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW I've been running current kernels on my niagara boxes without
> incident for several weeks.

It runs for me on Ultra 1, Ultra 5 IDE, Ultra 10 SCSI and Blade 100. 
Fails on E3500, V100 and Netra X1 so it's probably dependent on 
something in the device tree.

I will try bisecting and the suggested printk's but it takes time since 
I will be away from computers most of today.

-- 
Meelis Roos (mroos@linux.ee)
