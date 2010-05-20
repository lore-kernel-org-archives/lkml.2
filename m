Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0ETBAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:00:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:21500 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab0ETBAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:00:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,267,1272870000"; 
   d="scan'208";a="800088808"
Date: Thu, 20 May 2010 09:00:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at
 first
Message-ID: <20100520010032.GC4089@localhost>
References: <20100519174327.9591.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519174327.9591.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

The preceding comment "they need to go on the active_anon lru below"
also needs update.

Thanks,
Fengguang
