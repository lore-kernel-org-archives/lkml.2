Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2LTLT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:19:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab2LTLTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:19:20 -0500
Date: Thu, 20 Dec 2012 12:19:04 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/3] perf x86: Add precise sysfs attribute
Message-ID: <20121220111904.GC1241@krava.brq.redhat.com>
References: <1355929642-28392-1-git-send-email-jolsa@redhat.com>
 <1355929642-28392-3-git-send-email-jolsa@redhat.com>
 <20121220083925.GC3679@danjae>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220083925.GC3679@danjae>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 05:39:25PM +0900, Namhyung Kim wrote:
> On Wed, Dec 19, 2012 at 04:07:21PM +0100, Jiri Olsa wrote:
> > Adding sysfs precise attribute for cpu device (/sys/devices/cpu)
> > to show the maximum value for perf event precise attribute.
> > 
> > This will be initialy used for automated precise event perf test
> > and could be helpful otherwise. Arnaldo suggested to use this as
> > a guide for default adding of precise attribute for HW events.
> 
> Although I'm not aware of which architectures support precise feature,
> wouldn't it better putting this on architecture independent rather
> than just for x86 with fallback routine returning 0?

same here.. :) no idea if there's same concept in other archs

Anyway, I'd say it's not big change so once other archs get
interested, it's easy to make it global one.

Same like for event aliases moving to ppc now:
http://marc.info/?l=linux-kernel&m=135590210618224&w=2

thanks,
jirka
