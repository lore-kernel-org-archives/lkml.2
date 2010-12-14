Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0LNBIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:08:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:4657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701Ab0LNBIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:08:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,339,1288594800"; 
   d="scan'208";a="686824808"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <4D05EBA4.60202@gmail.com>
References: <1291255347.12777.116.camel@sli10-conroe>
	 <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>
	 <4D05EBA4.60202@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 09:08:44 +0800
Message-ID: <1292288924.2323.458.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 17:47 +0800, Tejun Heo wrote:
> Hello,
> 
> On 12/13/2010 01:41 AM, Shaohua Li wrote:
> >> Why add another set of macros?  Can't you just make the default one
> >> aligned?
> > how to do it without changing all arch code? There isn't cache line size
> > macro for all arch which could be used in vmlinux.lds.h, IIRC.
> 
> Can't we get around that with some ifdefferies?  And even if we'll
> have to change lds on every arch, I think we better do it that way.
I don't understand what you mean. defining a cachine line size macro for
all archs? There is such macro, but using it in vmlinux.ld.h always
report error. There is some other defines which can't be included in a
link script.
> It's not like the problem exists only on x86, right?
yes, though currently only x86 has it.

Thanks,
Shaohua

