Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2GER06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:26:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:43161 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2GER0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:26:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119213441"
Date: Thu, 5 Jul 2012 10:26:54 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/5] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
Message-ID: <20120705172654.GG32640@tassilo.jf.intel.com>
References: <1341254598-1379-3-git-send-email-andi@firstfloor.org>
 <1341256733.23484.11.camel@twins>
 <20120702195744.GG11413@one.firstfloor.org>
 <1341260540.23484.25.camel@twins>
 <20120702210008.GB14479@tassilo.jf.intel.com>
 <1341265014.23484.47.camel@twins>
 <20120702215722.GC14479@tassilo.jf.intel.com>
 <CABPqkBSdtV6FTqVestcmy_skyK5AFTeShoT6vDFk34A0XaXWDA@mail.gmail.com>
 <20120703040446.GJ11413@one.firstfloor.org>
 <CABPqkBT4Dgte73hM+im0VP-Px1rXXURcyHhsSA2RYXCTZSdOxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT4Dgte73hM+im0VP-Px1rXXURcyHhsSA2RYXCTZSdOxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 05:45:16PM +0200, Stephane Eranian wrote:
> On Tue, Jul 3, 2012 at 6:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> Well, the only way I can think of would be to request that the
> >> event be programmed with exclusive mode ALWAYS. That
> >> should not be to hard to add.
> >
> > I suspect it would need some special callbacks from the events core,
> > that's why I only tried on IvyBridge.
> >x
> You could simply add a check in the x86 init code like what is done
> with the pebs events and precise mode.

Ah requiring the user to set exclusive? Maybe. Right now perf does not even
have an option to set it. Would seem user unfriendly to me though.

-Andi
