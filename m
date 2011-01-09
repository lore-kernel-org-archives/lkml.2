Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1AIXbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:31:43 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:40988 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751672Ab1AIXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:31:40 -0500
Date: Mon, 10 Jan 2011 10:30:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Alex Elder <aelder@sgi.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC patch 27/28] trace event fs remove semicolons
Message-ID: <20110109233049.GB28803@dastard>
References: <20110109215927.633266833@efficios.com>
 <20110109220512.512120254@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110109220512.512120254@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 09, 2011 at 04:59:54PM -0500, Mathieu Desnoyers wrote:
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.  Remove extra trailing
> semicolons at the end of XFS and GFS2 trace event declarations.

Can you split the patch in to a separate XFs and GFS2 patches
(similar to the ext4-only patch) so we can take it through the XFS
tree as needed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
