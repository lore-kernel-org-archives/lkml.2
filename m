Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447Ab0J2DLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:11:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49456 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838Ab0J2DKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:10:55 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=QDC8QjlfTZkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=uUhmHlpbqtNAgwXJ0k4A:9 a=lK2TwTZKbjN4_ijIdwkKzXw5DX0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [ANNOUNCE] ktest.pl: Easy and flexible testing script for
 Linux Kernel Developers
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jon Masters <jcm@redhat.com>, corbet <corbet@lwn.net>,
        Jake Edge <jake@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, lmr@redhat.com,
        autotest@test.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <20101029002740.GA7688@suse.de>
References: <1288294944.18238.346.camel@gandalf.stny.rr.com>
	 <20101029002740.GA7688@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 28 Oct 2010 23:10:49 -0400
Message-ID: <1288321849.18238.395.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 17:27 -0700, Greg KH wrote:

> > Maybe this should go into the tools directory?
> 
> Yes please, I think that would be a great idea.

Should I try to get this into 2.6.37?  Since it is a stand alone tool, I
can hardly expect that it would break anything else.

-- Steve


