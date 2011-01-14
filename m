Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab1ANUre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:47:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1ANUrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:47:33 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=-y3Y6a2n3KcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=CoUFoIrb2FhbyYrJyyEA:9 a=OA5-iivjGRoD8lcnNzwA:7 a=s_JfsPG1iJg3Asuty9ZCmmEXhmoA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: remove syscall_exit_fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110114174928.GA1926@nowhere>
References: <4D301C0E.8090408@cn.fujitsu.com>
	 <20110114174928.GA1926@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 14 Jan 2011 15:47:30 -0500
Message-ID: <1295038050.16479.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 18:49 +0100, Frederic Weisbecker wrote:
> On Fri, Jan 14, 2011 at 05:49:02PM +0800, Lai Jiangshan wrote:
> > 
> > Use event_class_syscall_exit.fields instead.
> > Remove syscall_exit_fields.
> > Remove  syscall_get_enter_fields()
> 
> I assume you meant syscall_get_exit_fields()
> 
> > Add event_class_syscall_exit.fields initialization.
> > 
> > Indentation has to be changed also, otherwise the line
> > ".fields		= LIST_HEAD_INIT(event_class_syscall_exit.fields),"
> > I added will exceed 80 characters.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Nice!
> 
> Steve, if you don't mind I'll handle that one as I have another
> patch for syscalls tracing. 

Sure, go ahead.

-- Steve


