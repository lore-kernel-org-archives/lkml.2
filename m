Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab0CWXwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:52:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60695 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0CWXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:52:05 -0400
X-Authority-Analysis: v=1.1 cv=wckZLekju2+u3kt9osT+oU4XGSlOYx61urhSnO42l8s= c=1 sm=0 a=WtvnyVsu4OsA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=JfrnYn6hAAAA:8 a=U0ejs9t1kqFl08HKbVoA:9 a=TMvPd7QfVvGPp1nOC_YA:7 a=HHTgGr0Bi3RUUWv3vjBvq047yY4A:4 a=QEXdDO2ut3YA:10 a=3Rfx1nUSh_UA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 06/18] sched: Generate trace points only if scheduler
 tracing is enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100323010756.GB8292@nowhere>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <1269304340-25372-7-git-send-email-jack@suse.cz>
	 <20100323010756.GB8292@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 19:52:01 -0400
Message-ID: <1269388321.5363.377.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 02:07 +0100, Frederic Weisbecker wrote:
> On Tue, Mar 23, 2010 at 01:32:08AM +0100, Jan Kara wrote:
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> 
> 
> Note this one is an exception.
> Once tracing is enabled, we need the context switch
> tracer anyway to keep track of the pid:cmdline mappings.
> 
> 

Yes, the scheduling tracepoints are needed by several tracers. This must
be enabled by all.

But then again, I'm thinking it would be nicer to find a way to lower
the impact than just turning them off.

Perhaps only allow the individual disabling if CONFIG_EMBEDDED is set.

-- Steve


