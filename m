Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1ELIzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:55:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:37589 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1ELIzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:55:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,357,1301900400"; 
   d="scan'208";a="702692"
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110512082159.GB1030@htj.dyndns.org>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 16:55:20 +0800
Message-ID: <1305190520.2373.18.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Thu, 2011-05-12 at 16:21 +0800, Tejun Heo wrote:
> On Thu, May 12, 2011 at 10:48:13AM +0800, Shaohua Li wrote:
> > And the atomic64 approach not just improved the performance (which is
> > always welcomed), but it also fixes a bug for 32-bit system. The usage
> > of lglock is actually quite straightforward and is standard usage of
> > lglock (the comments of lglock.h declare such usage), just lglock
> > doesn't work for dynamatically allocated structure currently, which
> > needs a convert.
> 
> lglock doesn't seem like the right solution for the problem at hand.
> It's way too heavy handed and used to close a very small race window.
> It doesn't seem right.  Eric's idea seemed much better to me and I
> don't see why that can't be improved and used instead.  Would you be
> interested in looking that direction?
sure, but it's quite difficult to determine a @maxfuzzy in his proposal
I thought (and could confuse user), did I miss anything?

Thanks,
Shaohua


