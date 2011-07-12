Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1GLSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:09:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:55847 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638Ab1GLSJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:09:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,522,1304319600"; 
   d="scan'208";a="25012917"
Date: Tue, 12 Jul 2011 11:09:55 -0700
From: Wu Fengguang <fengguang.wu@intel.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Re. Revised [PATCH 3/3] mm/readahead: Remove the check for
 ra->ra_pages
Message-ID: <20110712180955.GA12562@localhost>
References: <cover.1310239575.git.rprabhu@wnohang.net>
 <323ddfc402a7f7b94f0cb02bba15acb2acca786f.1310239575.git.rprabhu@wnohang.net>
 <20110709205308.GC17463@localhost>
 <20110710125909.GA4460@Xye>
 <20110710155906.GB7432@localhost>
 <20110711230209.GA39196@Xye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711230209.GA39196@Xye>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  The check for ra->ra_pages is not required since fs like tmpfs which have
>  ra_pages set to 0 don't use filemap_fault as part of their VMA ops (it uses
>  shmem_fault). Also, page_cache_sync_readahead does its own check for ra_pages.
> 
>  Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thank you!
