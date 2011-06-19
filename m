Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1FSHu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 03:50:58 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:40744 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab1FSHu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 03:50:56 -0400
Date: Sun, 19 Jun 2011 10:50:53 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: 3.0-rc3: WARNING: at fs/fs-writeback.c:356
 writeback_single_inode+0x3e/0x18f()
In-Reply-To: <20110618173355.GB4652@localhost>
Message-ID: <alpine.SOC.1.00.1106191029590.14979@math.ut.ee>
References: <alpine.SOC.1.00.1106141213570.11764@math.ut.ee> <1308112976.2635.27.camel@pasglop> <20110618173355.GB4652@localhost>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Tested 3.0-rc3 on my PC (2 PATA disks, single duron CPU). Got several of 
> > > these in dmesg:
> > 
> > Same here on a powerpc64 machine while doing a fresh debian install
> > (while the installer's installing the packages), -rc3 as well.
> 
> Do you have some clue that this bug show up in between 3.0-rc1 and
> 3.0-rc3, or between 2.6.39 and 3.0-rc3?

Did some log grepping. 3.0-rc2 did not show them on 3 bootups but 
3.0-rc3 had it while I did dist-upgrade. I rebooted into the 3.0-rc2 
kernel and did todays dist-upgrade but the error did not show up, so 
it's probably post-rc2.

-- 
Meelis Roos (mroos@linux.ee)
