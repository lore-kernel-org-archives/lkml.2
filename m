Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1LMUjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:39:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:6597 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755669Ab1LMUjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:39:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101820855"
Date: Tue, 13 Dec 2011 12:38:56 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, lee.schermerhorn@hp.com,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch v3]numa: add a sysctl to control interleave allocation
 granularity from each node to improve I/O performance
Message-ID: <20111213203856.GA6312@tassilo.jf.intel.com>
References: <1323655125.22361.376.camel@sli10-conroe>
 <20111213190632.GA5830@tassilo.jf.intel.com>
 <alpine.DEB.2.00.1112131412320.27186@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112131412320.27186@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 02:12:58PM -0600, Christoph Lameter wrote:
> On Tue, 13 Dec 2011, Andi Kleen wrote:
> 
> > I would prefer to add a new policy (INTERLEAVE_MULTI or so) for this
> > instead of a global sysctl, that takes the additional parameter.
> 
> That would require a change of all scripts and code that uses
> MPOL_INTERLEAVE. Lets not do that.

Yes, but setting a sysctl would need the same right?

It's not clear that all workloads want this.

With a global switch only you cannot set it case by case.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
