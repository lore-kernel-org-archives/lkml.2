Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab2EDRwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:52:46 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41550 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2EDRwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:52:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120504170948.GE24639@google.com>
References: <CAMHCuPWNAWGMvEQz4yyBVuBJ9R86AZoH0MdUJbtumT+yd2CNMQ@mail.gmail.com>
	<1336078454.14207.105.camel@gandalf.stny.rr.com>
	<20120504170948.GE24639@google.com>
Date: Fri, 4 May 2012 23:22:43 +0530
Message-ID: <CAMHCuPWjCTDvGihodaojU84q0LuFa6VYPBmS+DdeeX0XPdtOiw@mail.gmail.com>
Subject: Re: workqueue tracing removed?
From: Sundar <sunder.svit@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 10:39 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> We do have tracepoints for work item queueing / execution but worker
> tracing is still missing.  What are you looking for?

I can get the workqueue insertion/execution/end events; but in the
latest kernels, i see that worker:0/1 or worker:u/0 (similar) shows
prominently on the traces, but I am not able to exactly pin point
which worker thread was being executed; i remember on the older
kernels, it used to be visible as something like work_dbs (ondemand
governor) or work_*.

Am i missing something here?

Thanks

-- 
---------
The views expressed in this email are personal and do not necessarily
echo my employers.
