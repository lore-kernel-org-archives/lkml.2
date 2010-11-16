Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520Ab0KPNN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:13:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240Ab0KPNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:13:25 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=5z8Dt6at09oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qqAg1-E_7G-I6sQUOBUA:9 a=Ttv1ej9VnS8NtOfhKpligrhoTZAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2 2/2] tracing,mm - add kernel pagefault tracepoint for
 x86 & x86_64
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
        andi@firstfloor.org, lwoodman@redhat.com, hch@infradead.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101116092306.GC1955@jolsa.brq.redhat.com>
References: <20101110164413.GA5360@nowhere>
	 <1289466549-7602-3-git-send-email-jolsa@redhat.com>
	 <20101115134325.GA5410@nowhere>
	 <1289830760.12418.598.camel@gandalf.stny.rr.com>
	 <20101116092306.GC1955@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 16 Nov 2010 08:13:23 -0500
Message-ID: <1289913203.12418.624.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 10:23 +0100, Jiri Olsa wrote:

> > Also, I'm going to start working on the stable ABI today.
> do you mean stable api for the hook you described above?
> or should I come up with smth..

The stable api will hook into the raw tracepoints (I'm calling the
tracepoints we have now "raw"). The tracepoints will not need anything
new so please continue with what you are doing.

-- Steve


