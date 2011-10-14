Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab1JNTbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:31:22 -0400
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:60789 "EHLO
	intmgw002.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753928Ab1JNTbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:31:21 -0400
X-Greylist: delayed 1201 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 15:31:21 EDT
Date: Fri, 14 Oct 2011 12:11:16 -0700
From: Arun Sharma <asharma@fb.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/4] perf: fix counter of ftrace events
Message-ID: <20111014191116.GA23666@dev1756.snc6.facebook.com>
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org>
 <1317052535-1765247-2-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317052535-1765247-2-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 07:55:32PM +0400, Andrew Vagin wrote:
> Each event adds some points to its counters. By default it adds 1,
> and a number of points may be transmited in event's parameters.
> 
> E.g. sched:sched_stat_runtime adds how long process has been running.
> 
> But this functionality was broken by v2.6.31-rc5-392-gf413cdb
> and now the event's parameters doesn't affect on a number of points.
> 
> TP_perf_assign isn't defined, so __perf_count(c) isn't executed and
> __count is always equal to 1.
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

Acked-by: Arun Sharma <asharma@fb.com>

 -Arun
