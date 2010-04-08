Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab0DHBDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 21:03:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:5386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab0DHBDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 21:03:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,166,1270450800"; 
   d="scan'208";a="611147869"
Subject: Re: hackbench regression due to commit 9dfc6e68bfe6e
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, netdev <netdev@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, alex.shi@intel.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1270665484.8141.47.camel@edumazet-laptop>
References: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
	 <alpine.DEB.2.00.1003250942080.2670@router.home>
	 <1269570902.9614.92.camel@alexs-hp.sh.intel.com>
	 <1270114166.2078.107.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004011050340.16531@router.home>
	 <1270195589.2078.116.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004050853300.23149@router.home>
	 <i2z84144f021004051030k7ff5190cyc083aa12c552dfac@mail.gmail.com>
	 <4BBA8DF9.8010409@kernel.org>
	 <1270542497.2078.123.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004061033330.18750@router.home>
	 <alpine.DEB.2.00.1004061552500.19151@router.home>
	 <1270591841.2091.170.camel@edumazet-laptop>
	 <1270607668.2078.259.camel@ymzhang.sh.intel.com>
	 <alpine.DEB.2.00.1004071130260.13261@router.home>
	 <4BBCB7B7.4040901@cs.helsinki.fi> <4BBCB868.2000705@cs.helsinki.fi>
	 <alpine.DEB.2.00.1004071319320.16159@router.home>
	 <1270665484.8141.47.camel@edumazet-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 08 Apr 2010 09:05:47 +0800
Message-Id: <1270688747.2078.383.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-07 at 20:38 +0200, Eric Dumazet wrote:
> Le mercredi 07 avril 2010 à 13:20 -0500, Christoph Lameter a écrit :
> > On Wed, 7 Apr 2010, Pekka Enberg wrote:
> > 
> > > Oh, sorry, I think it's actually '____cacheline_aligned_in_smp' (with four
> > > underscores) for per-cpu data. Confusing...
> > 
> > This does not particulary help to clarify the situation since we are
> > dealing with data that can either be allocated via the percpu allocator or
> > be statically present (kmalloc bootstrap situation).
> > 
> > --
> 
> Do we have a user program to check actual L1 cache size of a machine ?
If there is no, it's easy to write it as kernel exports the cache stat by
/sys/devices/system/cpu/cpuXXX/cache/indexXXX/

> 
> I remember my HP blades have many BIOS options, I would like to make
> sure they are properly set.
> 
> 
> 


