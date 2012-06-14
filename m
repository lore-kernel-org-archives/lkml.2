Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab2FNBaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:30:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:19633 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab2FNBaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165396155"
Date: Thu, 14 Jun 2012 09:29:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <dchinner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfs ip->i_lock: inconsistent {IN-RECLAIM_FS-W} ->
 {RECLAIM_FS-ON-W} usage
Message-ID: <20120614012959.GA7289@localhost>
References: <20120612012134.GA7706@localhost>
 <20120613123932.GA1445@localhost>
 <20120614012209.GM3019@devil.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614012209.GM3019@devil.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:22:09AM +1000, Dave Chinner wrote:
> On Wed, Jun 13, 2012 at 08:39:32PM +0800, Fengguang Wu wrote:
> > Hi Christoph, Dave,
> > 
> > I got this lockdep warning on XFS when running the xfs tests:
> 
> BTW, Fengguang, can you report XFS things to the xfs@oss.sgi.com
> list rather than LKML? I only noticed this because of the CC, but I
> pay much closer attention to the XFS list than I do LKML...

Sure, I'll CC xfs list in future.

Thanks,
Fengguang
