Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0EWNPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:15:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:6977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468Ab0EWNPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:15:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,285,1272870000"; 
   d="scan'208";a="801095892"
From: "Shi, Alex" <alex.shi@intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Duyck, Alexander H" <alexander.h.duyck@intel.com>
CC: "cl@linux.com" <cl@linux.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rjw@sisk.pl" <rjw@sisk.pl>
Date: Sun, 23 May 2010 21:15:36 +0800
Subject: RE: [PATCH v2] slub: move kmem_cache_node into it's own cacheline
Thread-Topic: [PATCH v2] slub: move kmem_cache_node into it's own cacheline
Thread-Index: Acr5ictHNdxgKk5gSFyDaOJ/tCu8fQA8BVHg
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B0B596908DB@shsmsx502.ccr.corp.intel.com>
References: <20100521214135.23902.55360.stgit@gitlad.jf.intel.com>
 <4BF79761.5000402@cs.helsinki.fi>
In-Reply-To: <4BF79761.5000402@cs.helsinki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4NDGAaS019611

sure. glad to a fix on this! 
 

-----Original Message-----
From: Pekka Enberg [mailto:penberg@cs.helsinki.fi] 
Sent: 2010Äê5ÔÂ22ÈÕ 16:36
To: Duyck, Alexander H
Cc: cl@linux.com; linux-mm@kvack.org; Shi, Alex; yanmin_zhang@linux.intel.com; akpm@linux-foundation.org; linux-kernel@vger.kernel.org; rjw@sisk.pl
Subject: Re: [PATCH v2] slub: move kmem_cache_node into it's own cacheline

Alexander Duyck wrote:
> This patch is meant to improve the performance of SLUB by moving the 
> local kmem_cache_node lock into it's own cacheline separate from kmem_cache.
> This is accomplished by simply removing the local_node when NUMA is enabled.
> 
> On my system with 2 nodes I saw around a 5% performance increase w/ 
> hackbench times dropping from 6.2 seconds to 5.9 seconds on average.  
> I suspect the performance gain would increase as the number of nodes 
> increases, but I do not have the data to currently back that up.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>

Thanks for the fix, Alexander!

Yanmin and Alex, can I have your Tested-by or Acked-by please so we can close "[Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e" 
after this patch is merged?

			Pekka
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
