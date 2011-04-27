Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab1D0QHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:07:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1D0QHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:07:14 -0400
Date: Wed, 27 Apr 2011 13:07:01 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Tim Blechmann <tim@klingt.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] Fix per-task profiling Re: [PATCH] perf: Allow set
 output buffer for tasks in the same thread group
Message-ID: <20110427160701.GC7807@ghostprotocols.net>
References: <1303657064.2239.25.camel@localhost>
 <1303664726.20212.1.camel@twins>
 <1303738838.2578.1.camel@localhost>
 <20110425152833.GB32069@ghostprotocols.net>
 <20110426204401.GB1746@ghostprotocols.net>
 <1303872046.23673.19.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303872046.23673.19.camel@minggr.sh.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 27, 2011 at 10:40:46AM +0800, Lin Ming escreveu:
> Tested and it works OK.

Thanks!
 
> But here is one thing make me confused.
> I thought that "--pid" and "--cpu" parameters are not allowed to be used
> at the same time. Otherwise, is it a task event or cpu event?
 
> Or does it mean that the event is only monitored when the "task" is
> running on the specified "cpu"?

This is an excellent question, my expectation is that it works as you
describe, but Documentation/perf/design.txt doesn't cover the case of
cpu != -1 and pid != -1, reading code...

- Arnaldo
