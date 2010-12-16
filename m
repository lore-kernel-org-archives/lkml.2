Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0LPAzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:55:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:23055 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab0LPAzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:55:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,351,1288594800"; 
   d="scan'208";a="868722879"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <4D08D568.5040801@gmail.com>
References: <1291255347.12777.116.camel@sli10-conroe>
	 <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>
	 <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe>
	 <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe>
	 <4D08CBF4.6040102@gmail.com>  <4D08D568.5040801@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 08:55:04 +0800
Message-ID: <1292460904.2323.466.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 22:49 +0800, Tejun Heo wrote:
> Hello,
> 
> On 12/15/2010 03:08 PM, Tejun Heo wrote:
> >> +#ifdef INTERNODE_CACHE_BYTES
> >> +#define INTERNODE_CACHEALIGNED						\
> >> +	. = ALIGN(INTERNODE_CACHE_BYTES);
> >> +#else
> >> +#define INTERNODE_CACHEALIGNED
> >> +#endif
> > 
> > Yeah, this looks good.
> 
> Just one more thing.  If you look at various arch linker scripts,
> cache line size is always present.  After all, RW_DATA_SECTION() needs
> it.  They're different define's or sometimes hardcoded values but it
> would be nice if we can take this chance to unify them and use it for
> this too.  Would you be interested in doing that?
might not, sorry.

