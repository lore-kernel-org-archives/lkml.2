Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0KJQ2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:28:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56808 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0KJQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:28:08 -0500
Date: Wed, 10 Nov 2010 17:28:06 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org, andi@firstfloor.org,
        lwoodman@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
Message-ID: <20101110162806.GD7205@basil.fritz.box>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
 <1289390172-9730-2-git-send-email-jolsa@redhat.com>
 <20101110132954.GA2101@infradead.org>
 <20101110134436.GD1949@jolsa.brq.redhat.com>
 <20101110135244.GA31638@elte.hu>
 <20101110150021.GA5750@nowhere>
 <20101110151750.GA11541@jolsa.brq.redhat.com>
 <20101110152001.GA5707@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110152001.GA5707@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 10:20:02AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 10, 2010 at 04:17:50PM +0100, Jiri Olsa wrote:
> > I guess I can take the regs out then.. would that patch be acceptable
> > afterwards..?
> 
> I really can't make much sense out of this whole trace point.  What
> use it the task_struct address for example?
> 
> What would be much more interesting is telling us if we had a
> major/minor fault, if ->page_mkwrite was called, etc.

Also on x86 I would log the error code.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
