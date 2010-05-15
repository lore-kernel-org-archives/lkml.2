Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab0EOAoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 20:44:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab0EOAon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 20:44:43 -0400
X-Authority-Analysis: v=1.1 cv=PaD2Wv+9xJqXNP3J8apim3QBTBpXOuB+BaCFQon6buA= c=1 sm=0 a=lF5mZmV-YUMA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=7d_E57ReAAAA:8 a=ddOBt4qP3uBnB0IAYEgA:9 a=Ytd-v563lRQ3tSbxVn0u0xNXJTcA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=D6-X0JM3zdQA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 13/13 v3] tracing: Comment the use of event_mutex with
 trace event flags
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20100514222140.GA14234@Krystal>
References: <20100514192246.079025623@goodmis.org>
	 <20100514192917.222882793@goodmis.org>  <20100514222140.GA14234@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 14 May 2010 20:44:40 -0400
Message-ID: <1273884280.27703.3131.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 18:21 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:

> > +	 * Note: Reads of flags do not hold the event_mutex since
> > +	 * they occur in critical sections. But the way flags
> > +	 * is currently used, these changes do no affect the code
> > +	 * except that when a change is made, it may have a slight
> > +	 * delay in propagating the changes to other CPUs due to
> > +	 * cacheing and such.
> 
> cacheing -> caching ?

hehe, I need spellcheck. I first wrote "caching", and thought to myself,
that looked wrong. Then I added the 'e'. Oh well.

> 
> Besides this minor nit:
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

-- Steve

> 
> >  	 */
> >  	unsigned int		flags;
> >  
> > -- 
> > 1.7.0
> > 
> > 
> 


