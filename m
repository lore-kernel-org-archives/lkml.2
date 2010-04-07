Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0DGIOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:14:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:57047 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0DGINy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:13:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,377,1267430400"; 
   d="scan'208";a="507031835"
Date: Wed, 7 Apr 2010 16:13:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Taras Glek <tglek@mozilla.com>, Johannes Weiner <hannes@cmpxchg.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Message-ID: <20100407081351.GA20322@localhost>
References: <4BBA6776.5060804@mozilla.com> <20100406095135.GB5183@cmpxchg.org> <20100407022456.GA9468@localhost> <4BBBF402.70403@mozilla.com> <u2p28c262361004062106neea0a64ax2ee0d1e1caf7fce5@mail.gmail.com> <20100407071408.GA17892@localhost> <v2r28c262361004070033z43fc5f07jcb5581a7a8c48310@mail.gmail.com> <20100407074732.GC17892@localhost> <g2q28c262361004070106le671ad63u965e8137ad2e4f41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g2q28c262361004070106le671ad63u965e8137ad2e4f41@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan,

> A few month ago, I saw your patch about enhancing readahead.
> At that time, many guys tested several size of USB and SSD which are
> consist of nand device.
> The result is good if we does readahead untile some crossover point.
> So I think we need readahead about file I/O in non-rotation device, too.
> 
> But startup latency is important than file I/O performance in some machine.
> With analysis at that time, code readahead of application affected slow startup.
> In addition, during bootup, cache hit ratio was very small.
> 
> So I hoped we can disable readahead just only code section(ie, roughly
> exec vma's filemap fault). :)
> 
> I don't want you to solve this problem right now.
> Just let you understand embedded system's some problem
> for enhancing readahead in future.  :)

Yeah, I've never heard of such a demand, definitely good to know it!

Thanks,
Fengguang
