Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab0HSBYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:24:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:14163 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab0HSBYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:24:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,230,1280732400"; 
   d="scan'208";a="598016625"
Date: Thu, 19 Aug 2010 09:24:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] page-types.c: fix name of unpoison interface
Message-ID: <20100819012415.GA5762@localhost>
References: <1281432464-14833-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1281432464-14833-9-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281432464-14833-9-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 06:27:43PM +0900, Naoya Horiguchi wrote:
> debugfs:hwpoison/renew-pfn is the old interface.
> This patch renames and fixes it.

Thanks for the fix!

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
