Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2EDRJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:09:55 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:42384 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2EDRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:09:54 -0400
Date: Fri, 4 May 2012 10:09:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sundar <sunder.svit@gmail.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: workqueue tracing removed?
Message-ID: <20120504170948.GE24639@google.com>
References: <CAMHCuPWNAWGMvEQz4yyBVuBJ9R86AZoH0MdUJbtumT+yd2CNMQ@mail.gmail.com>
 <1336078454.14207.105.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336078454.14207.105.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 03, 2012 at 04:54:14PM -0400, Steven Rostedt wrote:
> Might get a better answer if you Cc'd the people involved.
> 
> On Wed, 2012-05-02 at 15:36 +0530, Sundar wrote:
> > Hi All,
> > 
> > The CONFIG_WORKQUEUE_TRACER has been removed by the commit
> > 64166699752006f1a23a9cf7c96ae36654ccfc2c.
> > 
> > Any plans when this will be back?

We do have tracepoints for work item queueing / execution but worker
tracing is still missing.  What are you looking for?

Thanks.

-- 
tejun
