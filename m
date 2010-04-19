Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0DSTAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 15:00:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34286 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0DSTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 15:00:46 -0400
X-Authority-Analysis: v=1.1 cv=ZUag8tkj9kgmNMrzofuoEsXxpG43g9sRv4eUZcQ4+as= c=1 sm=0 a=ghPWWtjtHT8A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=5Qqb2krUl56flbgJoOAA:9 a=PkHT-_zng8ARzDnZqx9_d9hu6JAA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH v2] tracing: Dump either the oops's cpu source or all
 cpus buffers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100418192902.f3fad119.randy.dunlap@oracle.com>
References: <1271623810-23700-1-git-send-regression-fweisbec@gmail.com>
	 <1271639740-11653-1-git-send-regression-fweisbec@gmail.com>
	 <20100418192902.f3fad119.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 19 Apr 2010 15:00:43 -0400
Message-ID: <1271703643.10448.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-18 at 19:29 -0700, Randy Dunlap wrote:
> On Mon, 19 Apr 2010 03:15:40 +0200 Frederic Weisbecker wrote:
> 
> >  Documentation/kernel-parameters.txt |    6 +++-
> >  Documentation/trace/ftrace.txt      |    6 +++-
> >  drivers/char/sysrq.c                |    2 +-
> >  include/linux/ftrace.h              |    4 ++-
> >  include/linux/kernel.h              |   11 ++++++-
> >  kernel/trace/trace.c                |   51 ++++++++++++++++++++++++++--------
> >  6 files changed, 61 insertions(+), 19 deletions(-)

Frederic,

Send out v3 with Randy's updates and:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index e4cbca5..f6c68e8 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -789,8 +789,12 @@ and is between 256 and 4096 characters. It is defined in the file
> >  			as early as possible in order to facilitate early
> >  			boot debugging.
> >  
> >

