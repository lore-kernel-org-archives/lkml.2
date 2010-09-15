Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0IOQVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:21:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52753 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0IOQV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:21:29 -0400
X-Authority-Analysis: v=1.1 cv=2ipXt8Ao/PPbK329gQN1nC6XU/V8QMABDttguNTIlb0= c=1 sm=0 a=Age2qVpHITYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=uz0XKN4v8RSbsE9rLO4A:9 a=ziuidWAl8RIedq_hLABZTM9YLhQA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/3] tracing: Remove leftover
 FTRACE_ENABLE/DISABLE_MCOUNT enums
From: Steven Rostedt <rostedt@goodmis.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <11102.1284567033@localhost>
References: <20100915030139.444219083@goodmis.org>
	 <20100915030402.346004778@goodmis.org>  <11102.1284567033@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Sep 2010 12:21:26 -0400
Message-ID: <1284567686.5701.129.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 12:10 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 14 Sep 2010 23:01:42 EDT, Steven Rostedt said:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The enums for FTRACE_ENABLE_MCOUNT and FTRACE_DISABLE_MCOUNT were
> > used as commands to ftrace_run_update_code(). But these commands
> > were used by the old nasty ftrace daemon that has long been slain.
> 
> > -	FTRACE_START_FUNC_RET		= (1 << 5),
> > -	FTRACE_STOP_FUNC_RET		= (1 << 6),
> > +	FTRACE_START_FUNC_RET		= (1 << 3),
> > +	FTRACE_STOP_FUNC_RET		= (1 << 4),
> 
> This renumber isn't visible to user space, correct? (Asking because the enable/
> disable apparently *were* visible to the since-slain userspace daemon)

Nope, it's not visible to userspace, and the slain-daemon was a kernel
thread, not userspace.

-- Steve


