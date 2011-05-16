Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1EPKtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:49:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:8162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab1EPKtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:49:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,373,1301900400"; 
   d="scan'208";a="2740795"
Date: Mon, 16 May 2011 18:49:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/17] writeback: skip balance_dirty_pages() for
 in-memory fs
Message-ID: <20110516104947.GA5902@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140032.160664798@intel.com>
 <20110516104339.GB18520@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516104339.GB18520@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 06:43:39PM +0800, Christoph Hellwig wrote:
> Isn't this a fix that should go to Linus ASAP independent of the rest
> of this series to fix tmpfs?

Ah sorry for the confusing changelog: it's not a bug fix patch because
the impacted balance_dirty_pages trace point is not upstream yet.

I'll remove that "NULL dereference bug" from the changelog.

Thanks,
Fengguang
