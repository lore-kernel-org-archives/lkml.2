Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2HOOND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:13:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:58015 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2HOONB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:13:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,773,1336374000"; 
   d="scan'208";a="201732946"
Date: Wed, 15 Aug 2012 22:12:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mark Salter <msalter@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Aurelien Jacquiot <a-jacquiot@ti.com>,
        linux-c6x-dev@linux-c6x.org, Lennox Wu <lennox.wu@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] select GENERIC_ATOMIC64 for c6x/score/unicore32 archs
Message-ID: <20120815141233.GA32389@localhost>
References: <20120814153413.GA18601@localhost>
 <1344961371.30830.43.camel@deneb.redhat.com>
 <20120815023608.GA24697@localhost>
 <1345038181.2750.20.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345038181.2750.20.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 09:42:58AM -0400, Mark Salter wrote:
> On Wed, 2012-08-15 at 10:36 +0800, Fengguang Wu wrote:
> > > -#define L1_CACHE_BYTES        L2_CACHE_BYTES
> > > +#define L1_CACHE_SHIFT        L2_CACHE_SHIFT
> > > +#define L1_CACHE_BYTES        (1 << L2_CACHE_SHIFT)
> > 
> > Nitpick: the last line could better be:
> > 
> > +#define L1_CACHE_BYTES        (1 << L1_CACHE_SHIFT)
> > 
> > Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
> 
> Yes, I noticed that after sending the patch.
> 
> Should I push this through the c6x tree?

That'd be good. For consistency, will you also include the
GENERIC_ATOMIC64 chunk in the titled patch?

I can send Andrew an updated series (reducing the c6x changes, and
possibly the score/unicore32 bits) later on.

Thanks,
Fengguang
