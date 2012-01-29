Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab2A2GJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 01:09:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:33073 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab2A2GJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 01:09:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100771464"
Date: Sun, 29 Jan 2012 13:59:17 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Bad SSD performance with recent kernels
Message-ID: <20120129055917.GB8513@localhost>
References: <20120127060034.GG29272@MAIL.13thfloor.at>
 <20120128125108.GA9661@localhost>
 <1327757611.7199.6.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327757611.7199.6.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 02:33:31PM +0100, Eric Dumazet wrote:
> Le samedi 28 janvier 2012 à 20:51 +0800, Wu Fengguang a écrit :
> 
> > Would you please create a filesystem and large file on sda and run the
> > tests on the file? There was some performance bug on reading the raw
> > /dev/sda device file..
> 
> Hmm... latest kernel has the performance bug right now.
> 
> Really if /dev/sda is slow, we are stuck.

What's the block size? If it's < 4k, performance might be hurt.

        blockdev --getbsz /dev/sda

> FYI, I started a bisection.

Thank you! If the bisection would take much human time, it should be
easier to collect some blktrace data on reading /dev/sda for analyzes.

Thanks,
Fengguang
