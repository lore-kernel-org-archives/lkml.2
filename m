Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2JSRUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:20:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:14972 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab2JSRUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:20:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,613,1344236400"; 
   d="scan'208";a="229791467"
Date: Fri, 19 Oct 2012 10:20:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for
 INST_RETIRED:PREC_DIST
Message-ID: <20121019172018.GA2095@tassilo.jf.intel.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
 <1350658326-14715-3-git-send-email-eranian@google.com>
 <1350664077.2768.32.camel@twins>
 <CABPqkBQ5kCyGByFS-D62RYg2VUf_W-rJKDH=AzyrcaBPVY-eFQ@mail.gmail.com>
 <1350665152.2768.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350665152.2768.41.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This isn't limited to admin, right? So the above turns into a DoS on the
> > > console.
> > >
> > Ok, so how about a WARN_ON_ONCE() instead?
> 
> That should be fine I guess ;-)

imho there is need for a generic mechanism to return an error string
to the user program without such hacks.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
