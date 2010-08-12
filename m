Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683Ab0HLVQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:16:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0HLVQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:16:23 -0400
X-Authority-Analysis: v=1.1 cv=mWMe3HXt1P3ELXxrmMgI9QKdSRnwjSxQbBh3ay0KAh4= c=1 sm=0 a=8rnxU5RriJ8A:10 a=GzHTLUccyWwA:10 a=IXo+6rlC6z1XzBFn1RNpIA==:17 a=VwQbUJbxAAAA:8 a=6pkSVfNEwQbTKloNzVkA:9 a=QR2zPhHLi9o70Jj77ZFVa3ru9ZoA:4 a=IXo+6rlC6z1XzBFn1RNpIA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.87.39
Message-Id: <20100812211422.440965474@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 12 Aug 2010 17:14:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: more updates for 2.6.36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

These changes are on top of my previous pull request.

Also, I notice that a fix that did not make the 35-rc never got
into tip. This is the "FORMAT TOO BIG" that the scsi events output.
And I do not want another major release to have this bug in it.

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-2


Mike Frysinger (1):
      tracing: Extend recordmcount to better support Blackfin mcount

Steven Rostedt (1):
      tracing/events: Convert format output to seq_file

----
 kernel/trace/trace_events.c |  208 +++++++++++++++++++++++++++++--------------
 scripts/recordmcount.pl     |    7 ++-
 2 files changed, 147 insertions(+), 68 deletions(-)
