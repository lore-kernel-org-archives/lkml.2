Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1KUJk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:40:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:63814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1KUJk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:40:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,546,1315206000"; 
   d="scan'208";a="87658476"
Message-Id: <20111121091819.394895091@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 17:18:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 0/8] readahead stats/tracing, backwards prefetching and more
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I'm getting around to pick up the readahead works again :-)

This first series is mainly to add some debug facilities, to support the long
missed backwards prefetching capability, and some old patches that somehow get
delayed (shame me).

The next step would be to better handle the readahead thrashing situations.
That would require rewriting part of the algorithms, this is why I'd like to
keep the backwards prefetching simple and stupid for now.

When (almost) free of readahead thrashing, we'll be in a good position to lift
the default readahead size. Which I suspect would be the single most efficient
way to improve performance for the large volumes of casually maintained Linux
file servers.

Thanks,
Fengguang

