Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab1D1AFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:05:04 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57936 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab1D1AFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:05:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgIEANiuuE15LHHJgWdsb2JhbAClfhUBARYmJcUJDoVoBJU9h1I
Date: Thu, 28 Apr 2011 10:04:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: drosenberg@vsecurity.com, ak@linux.intel.com, eugeneteo@kernel.org,
        aelder@sgi.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [8/106] xfs: prevent leaking uninitialized stack
 memory in FSGEOMETRY_V1
Message-ID: <20110428000449.GK12436@dastard>
References: <20110426212.641772347@firstfloor.org>
 <20110426211246.2E1863E1887@tassilo.jf.intel.com>
 <20110427052610.GH12436@dastard>
 <20110427150039.GP16484@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427150039.GP16484@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 05:00:39PM +0200, Andi Kleen wrote:
> > > v2 switches to memset() to avoid future issues if structure members
> > > change, on suggestion of Dave Chinner.
> > 
> > Did you grab the followup patch that fixed the stack corruption
> > this change caused?
> 
> No. Which commit ID is that?

commit af24ee9ea8d532e16883251a6684dfa1be8eec29. I see it is patch
52 of the series, so everything shoul dbe OK. It took a while for
all the patches in the series to trickle into my mail box....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
