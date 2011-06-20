Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1FTF5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:57:46 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:35984 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1FTF5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:57:45 -0400
Date: Mon, 20 Jun 2011 08:57:43 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Christoph Hellwig <hch@infradead.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 3.0-rc3: WARNING: at fs/fs-writeback.c:356
 writeback_single_inode+0x3e/0x18f()
In-Reply-To: <20110619143422.GA19875@infradead.org>
Message-ID: <alpine.SOC.1.00.1106200856240.15133@math.ut.ee>
References: <alpine.SOC.1.00.1106141213570.11764@math.ut.ee> <1308112976.2635.27.camel@pasglop> <20110619143422.GA19875@infradead.org>
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
> Does commit 50338b889dc504c69e0cb316ac92d1b9e51f3c8a fix the issue for
> you?

I updated to yesterdays git and tested it. Booting up, doing a debian 
unstable upgrade and moving 20G files around did not cause the warnings 
so far, so it seems to have been fixed.

-- 
Meelis Roos (mroos@linux.ee)
