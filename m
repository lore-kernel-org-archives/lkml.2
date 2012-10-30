Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab2J2QHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:07:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:25567 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759864Ab2J2QHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:07:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,672,1344236400"; 
   d="scan'208";a="234114776"
Date: Wed, 31 Oct 2012 00:05:53 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/8] perf ui/browser: Integrate script browser into
 main hists browser
Message-ID: <20121030160553.GA21738@feng-snb>
References: <1351569369-26732-1-git-send-email-feng.tang@intel.com>
 <1351569369-26732-6-git-send-email-feng.tang@intel.com>
 <20121029145423.GF6754@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029145423.GF6754@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 12:54:23PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 30, 2012 at 11:56:06AM +0800, Feng Tang escreveu:
> > Integrate the script browser into "perf report" framework, users can
> > use function key 'r' or the drop down menu to list all perf scripts
> > and select one of them, just like they did for the annotation.
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> 
> I noticed this comment on another patch:
> 
> --------------------------
> This initial version only enables it for 'perf report', by checking
> the "timer" parameter of perf_evsel__hists_browser() equals NULL.
> --------------------------
> 
> Yeah, one can say that if a timer is provided, we can say its 'top' and
> not 'report', at least as things stand now.
> 
> So please add a 'is_top(void *timer)' so that we know the intent more
> clearly and use it to avoid showing the 'r' key when in 'top' mode, ok?

Will do and thanks for the catch. I once thought about hiding script option
for 'top' mode, but forgot to follow it on.

Thanks,
Feng

