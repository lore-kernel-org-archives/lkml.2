Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0JPNPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 09:15:13 -0400
Received: from relay1.sgi.com ([192.48.179.29]:40106 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab0JPNPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 09:15:10 -0400
Date: Sat, 16 Oct 2010 08:15:05 -0500
From: Robin Holt <holt@sgi.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: ftrace does not work on cpus > 999.
Message-ID: <20101016131505.GW14064@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just started looking into using ftrace to identify a difficult to diagnose
userland set of processes when I noticed that the .../trace/per_cpu
directory only contains entries for cpus 0-999.  I have not looked at
what else may not work.  For the cpus that are listed, I am able to grep
trace buffer information so it is mostly working.

I will be away from email for most of today, but may get back to this
tonight.  If there are any suggestions, I will happily give them a try.

Thanks,
Robin
