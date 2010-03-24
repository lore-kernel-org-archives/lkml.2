Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab0CXUbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:31:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42648 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab0CXUbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:31:42 -0400
X-Authority-Analysis: v=1.1 cv=wckZLekju2+u3kt9osT+oU4XGSlOYx61urhSnO42l8s= c=1 sm=0 a=FhWVZtC4hY8A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=lXCcdGLKZGb9ars_fFUA:9 a=PMqE0pdiyQIKgXgR03t1LAJMBfkA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33 GP fault only when built with tracing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4BAA743E.6080205@oracle.com>
References: <4BA2B69D.3000309@oracle.com>
	 <1268956555.758.18.camel@gandalf.stny.rr.com>
	 <20100319005901.GB23020@Krystal> <4BA3C0CF.6070005@oracle.com>
	 <20100319184610.GA29161@Krystal>
	 <20100323082643.dbf77c46.randy.dunlap@oracle.com>
	 <20100324012053.GA17187@Krystal>  <4BAA743E.6080205@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 24 Mar 2010 16:31:39 -0400
Message-ID: <1269462699.2957.3029.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 13:21 -0700, Randy Dunlap wrote:
> On 03/23/10 18:20, Mathieu Desnoyers wrote:
> > 
> > While we wait for the sun to move to other time zones, can you check if the
> > following patch fixes your problem ?
> > 
> 
> Hi Mathieu,
> Yes, this works.  Thanks.
> 
> I'll test Li's patch now...
> 

If it works, can you send me your "Tested-by". I have it queued to go.

Thanks,

-- Steve


