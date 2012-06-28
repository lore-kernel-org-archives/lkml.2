Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2F1RaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2F1RaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:30:06 -0400
Date: Thu, 28 Jun 2012 14:29:31 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 3/3] perf script/python: Pass event/thread/dso name
 and symbol info to event handler in python
Message-ID: <20120628172931.GA18586@infradead.org>
References: <1339999839-14007-1-git-send-email-feng.tang@intel.com>
 <1339999839-14007-4-git-send-email-feng.tang@intel.com>
 <20120627185817.GD20530@infradead.org>
 <20120628165027.43806b3d@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628165027.43806b3d@feng-i7>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 28, 2012 at 04:50:27PM +0800, Feng Tang escreveu:
> On Wed, 27 Jun 2012 15:58:17 -0300
> Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > Now old scrips will break, as the tuple they expect:
> > 
> >  (attr, sample, raw_data)
> > 
> > will not be there.
> 
> Actually, there are no such scripts out. Current perf python script only
> supports the trace point type, while perl scriptt has the support for
> general events. It is my first patch "perf script: Add general python 
> handler to process non-tracepoint events" which bring this (attr, sample,
> raw_data) in to be on the same page as perl. So this won't be a problem
> when the 3 patches are merged together. 

Cool, I forgot about that, thanks for correcting me :-)

But even then, perf and python diverged in this... anyway, not a big
deal, I guess, the info available for perl scripts will be available in
the dict as well, right?
 
> > The first two patches in this series don't apply anymore, please find
> > them attached fixed, please check if they work as expected.

> Thanks a lot for fixing them, I'll generate perf tool patch against the
> "perf/core" branch of your git tree on kernel.org from now on.
> 
> Btw, I have 2 more python scripts based on these patches, will add them
> to this serie for your review.

Ok, will take a look at them.

- Arnaldo
