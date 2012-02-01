Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2BAIki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 03:40:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:49457 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab2BAIkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 03:40:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101875840"
Date: Wed, 1 Feb 2012 16:30:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Young <dyoung@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
Message-ID: <20120201083032.GA6774@localhost>
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
 <CAOJsxLGVS3bK=hiKJu4NwTv-Nf8TCSAEL4reSZoY4=44hPt8rA@mail.gmail.com>
 <4F28EC9D.7000907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F28EC9D.7000907@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:41:17PM +0800, Dave Young wrote:
> On 02/01/2012 03:32 PM, Pekka Enberg wrote:
> 
> > On Wed, Feb 1, 2012 at 8:34 AM, Dave Young <dyoung@redhat.com> wrote:
> >> tools/ is the better place for vm tools which are used by many people.
> >> Moving them to tools also make them open to more users instead of hide in
> >> Documentation folder.
> > 
> > For moving the code:
> > 
> > Acked-by: Pekka Enberg <penberg@kernel.org>

I have no problem with the move -- actually I sent a similar patch
long time ago to Andrew ;)

Will git-mv end up with a better commit?

> >> Also fixed several coding style problem.
> > 
> > Can you please make that a separate patch?
> 
> 
> Will do.
> 
> BTW, I think tools/slub/slabinfo.c should be included in tools/vm/ as
> well, will move it in v2 patch

CC Christoph. Maybe not a big deal since it's already under tools/.

Thanks,
Fengguang
