Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0KJPUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:20:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0KJPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:20:20 -0500
Date: Wed, 10 Nov 2010 10:20:02 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Christoph Hellwig <hch@infradead.org>, rostedt@goodmis.org,
        andi@firstfloor.org, lwoodman@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] tracing,mm - add kernel pagefault tracepoint for x86
 & x86_64
Message-ID: <20101110152001.GA5707@infradead.org>
References: <1289390172-9730-1-git-send-email-jolsa@redhat.com>
 <1289390172-9730-2-git-send-email-jolsa@redhat.com>
 <20101110132954.GA2101@infradead.org>
 <20101110134436.GD1949@jolsa.brq.redhat.com>
 <20101110135244.GA31638@elte.hu>
 <20101110150021.GA5750@nowhere>
 <20101110151750.GA11541@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110151750.GA11541@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:17:50PM +0100, Jiri Olsa wrote:
> I guess I can take the regs out then.. would that patch be acceptable
> afterwards..?

I really can't make much sense out of this whole trace point.  What
use it the task_struct address for example?

What would be much more interesting is telling us if we had a
major/minor fault, if ->page_mkwrite was called, etc.
