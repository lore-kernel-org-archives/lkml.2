Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab2JIEEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:04:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:34929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab2JIEEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:04:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,557,1344236400"; 
   d="scan'208";a="223873781"
Date: Tue, 9 Oct 2012 10:11:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the thermal tree
Message-ID: <20121009021111.GA6644@localhost>
References: <20121008110205.1e0abbe228186fcf30afad74@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008110205.1e0abbe228186fcf30afad74@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:02:05AM +1100, Stephen Rothwell wrote:
> Hi Zhang,
> 
> After merging the thermal tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/thermal/cpu_cooling.c: In function 'get_idr':
> drivers/thermal/cpu_cooling.c:89:14: error: 'MAX_ID_MASK' undeclared (first use in this function)
> 
> Caused by commit 023614183768 ("thermal: add generic cpufreq cooling
> implementation") interacting with commit 125c4c706b68 ("idr: rename
> MAX_LEVEL to MAX_IDR_LEVEL") which very recently entered Linus' tree.
> 
> I have applied the following fix patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 8 Oct 2012 10:56:56 +1100
> Subject: [PATCH] thermal: fix for for MAX_ID_MASK to MAX_IDR_MASK rename

Thank you Stephen! Sorry for all the troubles on the rename..

Thanks,
Fengguang
