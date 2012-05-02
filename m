Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2EBXHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:07:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:1439 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab2EBXHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:07:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148688142"
Date: Thu, 3 May 2012 07:06:54 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Ulrich Drepper <drepper@akkadia.org>, akpm@linux-foundation.org,
        dyoung@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, n-horiguchi@ah.jp.nec.com
Subject: Re: [PATCH] Cleanup page-type.c
Message-ID: <20120502230654.GB6926@localhost>
References: <201205021441.q42Ef1ap026902@drepperk.user.openhosting.com>
 <4FA17A95.9050603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA17A95.9050603@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 02:19:01PM -0400, KOSAKI Motohiro wrote:
> (5/2/12 10:41 AM), Ulrich Drepper wrote:
> > Compiling page-type.c with a recent compiler produces many warnings,
> > mostly related to signed/unsigned comparisons.  This patch cleans up
> > most of them.
> > 
> > One remaining warning is about an unused parameter.  The<compiler.h>
> > file doesn't define a __unused macro (or the like) yet.  This can be
> > addressed later.
> > 
> > The line numbers for this patch correspond to the file changed to remove
> > the duplicate definitions of the KPF_* macros which is contained in
> > another patch.  It should apply cleanly albeit with warnings even without
> > that patch applied first.
> > 
> > 
> > Signed-off-by: Ulrich Drepper<drepper@gmail.com>
> > 
> >   page-types.c |   22 +++++++++++-----------
> >   1 file changed, 11 insertions(+), 11 deletions(-)
> 
> Looks good to me.
>  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Fengguang Wu <fengguang.wu@intel.com>

> offtopic:
> Wu, I have (unrelated) one question. page-type is used from production
> systems nowadays. Why don't you want to move page-type.c into tools/ dir?

I was actually thinking the same with you, and the good news is, it's
recently moved into tools/ by Dave Young:

commit c6dd897f3bfc54a44942d742d6dfa842e33d88e0
Author: Dave Young <dyoung@redhat.com>
Date:   Wed Mar 28 14:42:55 2012 -0700

    mm: move page-types.c from Documentation to tools/vm

Thanks,
Fengguang
