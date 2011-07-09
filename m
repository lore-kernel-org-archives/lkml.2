Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1GIUrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 16:47:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:47467 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1GIUrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 16:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,505,1304319600"; 
   d="scan'208";a="25999356"
Date: Sat, 9 Jul 2011 13:47:33 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: Re: [PATCH 1/3] mm/readahead: Change the check for PageReadahead
 into an else-if
Message-ID: <20110709204733.GA17463@localhost>
References: <cover.1310239575.git.rprabhu@wnohang.net>
 <5a2186efeb299af150b1bef10f1c3a428722b3de.1310239575.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a2186efeb299af150b1bef10f1c3a428722b3de.1310239575.git.rprabhu@wnohang.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 03:41:18AM +0800, Raghavendra D Prabhu wrote:
> >From 51daa88ebd8e0d437289f589af29d4b39379ea76, page_sync_readahead coalesces
> async readahead into its readahead window, so another checking for that again is
> not required.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thank you!
