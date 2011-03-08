Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1CHB2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:28:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:63883 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab1CHB2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:28:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,280,1297065600"; 
   d="scan'208";a="399072817"
Date: Mon, 7 Mar 2011 17:26:13 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Petr Holasek <pholasek@redhat.com>
Cc: linux-kernel@vger.kernel.org, emunson@mgebm.net, anton@redhat.com,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlb: /proc/meminfo shows data for all sizes of
 hugepages
Message-ID: <20110308012613.GA2391@tassilo.jf.intel.com>
References: <1299503155-6210-1-git-send-email-pholasek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299503155-6210-1-git-send-email-pholasek@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 02:05:55PM +0100, Petr Holasek wrote:
> /proc/meminfo file shows data for all used sizes of hugepages
> on system, not only for default hugepage size.

When I wrote that It was intentional to only report the 
default page size here. The other page sizes are reported
in sysfs instead.

The reason was to avoid breaking any applications that
read /proc/meminfo today.

I suspect your patch will break them.

-Andi
