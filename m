Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1FNKjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:39:06 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:59882 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab1FNKjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:39:04 -0400
Date: Tue, 14 Jun 2011 13:39:03 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.0-rc3: Kernel unaligned access at end_writeback+0x38
In-Reply-To: <alpine.SOC.1.00.1106141331430.16316@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1106141338270.16316@math.ut.ee>
References: <alpine.SOC.1.00.1106141331430.16316@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tested 3.0-rc3 on a sparc64 machine and got loads of these warnings:
> 
> [   71.909647] Kernel unaligned access at TPC[4d95b8] end_writeback+0x38/0xc0

Another machinbe also shows
Kernel unaligned access at TPC[4ee800] iget_locked+0x60/0x160
with 3.0.rc2-0400-...

-- 
Meelis Roos (mroos@linux.ee)
