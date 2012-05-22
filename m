Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235Ab2EVTSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:18:00 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:32858 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2EVTR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:17:58 -0400
Date: Tue, 22 May 2012 22:17:57 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
In-Reply-To: <20120522.151217.278388169416093561.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1205222217070.27144@math.ut.ee>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee> <20120522.151217.278388169416093561.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Just tested 3.4.0-02580-g72c04af on about 10 machines. While most of 
> > them work (including 3 different sparc64 machines with real scsi disks), 
> > Sun Netra X1 with pata_ali and IDE disk consistently fails to boot. sda 
> > is recognized but no partitions. 3.3.0 works fine, as did something 
> > around 3.4-rc7 (plain 3.4 not tested yet). No other IDE machines tested 
> > yet since I have none with remote console at the moment.
> 
> 3.4-rc7 until 72c04af is about 3500 changes, we'll need to narrow this
> down further.
> 
> I would first check to make sure that 3.4.0-final doesn't have the
> problem.
> 
> If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04af.  One
> possibility could be the sparc64 NOBOOTMEM conversion that went into
> the merge window.

Meanwhile tested that 3.4 was OK and started bisecting. It will take 
time because I can access the system only some iterations per day.

-- 
Meelis Roos (mroos@linux.ee)
