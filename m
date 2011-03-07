Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab1CGQfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:35:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:63097 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1CGQfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:35:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,277,1297065600"; 
   d="scan'208";a="894651330"
Date: Mon, 7 Mar 2011 08:35:13 -0800
From: Andi Kleen <ak@linux.intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Message-ID: <20110307163513.GC13384@alboin.amr.corp.intel.com>
References: <1299182391-6061-1-git-send-email-andi@firstfloor.org>
 <1299182391-6061-9-git-send-email-andi@firstfloor.org>
 <20110307172609.8A01.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307172609.8A01.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't we need to make per zone stastics? I'm afraid small dma zone 
> makes much thp-splitting and screw up this stastics.

Does it? I haven't seen that so far.

If it happens a lot it would be better to disable THP for the 16MB DMA
zone at least. Or did you mean the 4GB zone?

-Andi
