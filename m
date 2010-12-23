Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0LWCiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:38:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:30891 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab0LWCit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:38:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,217,1291622400"; 
   d="scan'208";a="639599700"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <4D0F7C5A.1060107@gmail.com>
References: <1291255347.12777.116.camel@sli10-conroe>
	 <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>
	 <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe>
	 <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe>
	 <4D08CBF4.6040102@gmail.com> <1292460817.2323.465.camel@sli10-conroe>
	 <20101216054620.GA3241@merkur.ravnborg.org>
	 <1292479000.2323.468.camel@sli10-conroe>  <4D09E0EE.7040605@gmail.com>
	 <1292808518.10593.8.camel@sli10-conroe>  <4D0F7C5A.1060107@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Dec 2010 10:38:34 +0800
Message-ID: <1293071914.10593.10.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 23:55 +0800, Tejun Heo wrote:
> Hello,
> 
> On 12/20/2010 02:28 AM, Shaohua Li wrote:
> >> Not being able to cross build every arch is okay but you at least need
> >> to make an effort to make things easily applicable to other archs and
> >> avoid adding subtle ugliness like the above.  Please at least try to
> >> look at other arch codes and see how things can be made to work across
> >> different archs.  Setting up cross compilers for the major archs, for
> >> example, sparc, power and ia64 isn't that difficult either.
> >
> > This still needs I fix every arch, for example, as Sam pointed out,
> > spark build will fail. I really have the bandwidth and capability to do
> > this. Increment changes are always preferred. My original patch is
> > trying to follow increment changes way.
> 
> Yeah, well, in my experience, those approaches usually just end up
> piling partial conversions on top of different set of partial
> conversions.  It's not like we're talking about a major arch dependent
> feature it's just a matter of looking through different arch codes,
> maybe test building some, pushing things to linux-next and dealing
> with fallouts if there is any.  I'll try to do it myself.
Thanks for doing it and sorry I didn't do it.
The first patch in the series isn't related to this issue, please
consider merge it.

Thanks,
Shaohua

