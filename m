Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0H0NxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:53:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43181 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0H0NxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MvCaVQ7HJ9K9ZvcvIVQuj7rXFrZ+3qz+KCcJrPtfaSJJW6qWz8wvihQCbmc4kdRSbe
         LHh+IQPR6OyBKwx+3oQA+30UkkXyrVVfuwr3nSnb69BXWEWYKc0b5s5WdwEqYxNqa2bV
         YX1SWo2EuYv+uF5CwMRe5O+8UGCYbhJ6J0QCU=
Date: Fri, 27 Aug 2010 17:53:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip] perf, x86, Pentium4: Add RAW events verification
Message-ID: <20100827135303.GA5405@lenovo>
References: <20100825182334.GB14874@lenovo> <1282886480.12588.17.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282886480.12588.17.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 01:21:20PM +0800, Lin Ming wrote:
> On Thu, 2010-08-26 at 02:23 +0800, Cyrill Gorcunov wrote:
> > Implements verification of
> > 
> > - Bits of ESCR EventMask field (meaningful bits in field are hardware
> >   predefined and others bits should be set to zero)
> > 
> > - INSTR_COMPLETED event (it is available on predefined cpu model only)
> > 
> > - Thread shared events (they should be guarded by "perf_event_paranoid"
> >   sysctl due to security reason). The side effect of this action is
> >   that PERF_COUNT_HW_BUS_CYCLES become a "paranoid" general event.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > CC: Lin Ming <ming.m.lin@intel.com>
> > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > ---
... 
> I have tested this patch on a 16cpus Netburst server.
> The predefined hardware/cache events work well.
> 
> Thanks,
> Lin Ming
> 

Thanks a lot, Ming!
