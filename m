Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1DANCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:02:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:13548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab1DANCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:02:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,282,1299484800"; 
   d="scan'208";a="727920575"
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <1301589129.2250.499.camel@laptop>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>
	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>
	 <1301418533.2250.419.camel@laptop>
	 <20110329174556.GC24129@ghostprotocols.net>  <4D92818A.8020405@hitachi.com>
	 <1301561155.14111.288.camel@minggr.sh.intel.com>
	 <1301580117.4859.286.camel@twins>  <1301582056.2271.15.camel@localhost>
	 <1301588922.2250.498.camel@laptop>  <1301589129.2250.499.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 21:02:14 +0800
Message-Id: <1301662934.2399.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 00:32 +0800, Peter Zijlstra wrote:
> On Thu, 2011-03-31 at 18:28 +0200, Peter Zijlstra wrote:
> > 
> > You could even first build the basic block tree and only follow those
> > branches that end up covering the region IP is in.
> 
> s/tree/directed-graph/ clearly the basic blocks don't form a tree and
> can contain cycles.

There may be multiple different paths from the beginning of the function
to the point we are interested in.

Any idea how to handle this case?

