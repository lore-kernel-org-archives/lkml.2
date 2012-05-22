Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab2EVTMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:12:22 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49988 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2EVTMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:12:21 -0400
Date: Tue, 22 May 2012 15:12:17 -0400 (EDT)
Message-Id: <20120522.151217.278388169416093561.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.4.0-02580-g72c04af regression on sparc64 - partitions not
 recognized
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>
References: <alpine.SOC.1.00.1205221200050.9585@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 12:12:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Tue, 22 May 2012 12:14:05 +0300 (EEST)

> Just tested 3.4.0-02580-g72c04af on about 10 machines. While most of 
> them work (including 3 different sparc64 machines with real scsi disks), 
> Sun Netra X1 with pata_ali and IDE disk consistently fails to boot. sda 
> is recognized but no partitions. 3.3.0 works fine, as did something 
> around 3.4-rc7 (plain 3.4 not tested yet). No other IDE machines tested 
> yet since I have none with remote console at the moment.

3.4-rc7 until 72c04af is about 3500 changes, we'll need to narrow this
down further.

I would first check to make sure that 3.4.0-final doesn't have the
problem.

If 3.4.0-final is OK, start bisecting from v3.4.0 until 72c04af.  One
possibility could be the sparc64 NOBOOTMEM conversion that went into
the merge window.
