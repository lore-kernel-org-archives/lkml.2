Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab0LMAlb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:41:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:46958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0LMAla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:41:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,333,1288594800"; 
   d="scan'208";a="635644391"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <4D0243DD.3090507@gmail.com>
References: <1291255347.12777.116.camel@sli10-conroe>
	 <4D0243DD.3090507@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 08:41:26 +0800
Message-ID: <1292200886.2323.15.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 23:14 +0800, Tejun Heo wrote:
> Hello,
> 
> On 12/02/2010 03:02 AM, Shaohua Li wrote:
> > percpu readmostly section should start and end at address cachline aligned.
> > Idealy we should change PERCPU_VADDR/PERCPU, but I can't change all arch code, so
> > I add new macros for x86.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> Why add another set of macros?  Can't you just make the default one
> aligned?
how to do it without changing all arch code? There isn't cache line size
macro for all arch which could be used in vmlinux.lds.h, IIRC.

Thanks,
Shaohua

