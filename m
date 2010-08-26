Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0HZObt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:31:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab0HZObs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:31:48 -0400
Date: Thu, 26 Aug 2010 10:31:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100826143105.GK4879@redhat.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100825094819.GB3198@erda.amd.com>
 <20100825104130.GA27891@elte.hu>
 <20100825110006.GB27891@elte.hu>
 <20100825201106.GH4879@redhat.com>
 <20100826090008.GA22783@erda.amd.com>
 <AANLkTim3+u-fV-RAC=Odede6BfGdYoXsN55Tqw6iSfVT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim3+u-fV-RAC=Odede6BfGdYoXsN55Tqw6iSfVT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 01:18:29PM +0400, Cyrill Gorcunov wrote:
> On Thu, Aug 26, 2010 at 1:00 PM, Robert Richter <robert.richter@amd.com> wrote:
> ...
> >
> > This could also be a race in the counter handling code, or we do not
> > proper count the number of handled counters. Maybe 2 counters actually
> > fired but we only noticed one counter and then accidentially cleared
> > the 2nd without processing it.
> >
> > -Robert
> >
> 
> Any chance to get it tested on P4 machine since it has a bit
> different design?

Well P4 uses a different pmu irq handler, so I am not sure it will give us
much insight.  I haven't noticed this on an AMD or an intel i5 either.

Cheers,
Don
