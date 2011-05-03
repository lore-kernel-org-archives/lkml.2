Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1ECObu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:31:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36007 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1ECObs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:31:48 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=U_JMZpF1WL4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yiXyavQA61TBIn8mQQAA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 02/32] trace event sample remove semicolons,
 specify need for ifdef around declarations
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20110502213211.465572692@efficios.com>
References: <20110502211123.163877033@efficios.com>
	 <20110502213211.465572692@efficios.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 May 2011 10:31:45 -0400
Message-ID: <1304433105.25414.2393.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-02 at 17:11 -0400, Mathieu Desnoyers wrote:
> plain text document attachment
> (trace-event-sample-remove-semicolons.patch)
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.
> 
> Protecting declarations with ifndef _TRACE_SAMPLE_DEF_ is required if we want to
> ensure that, e.g., structure forward declarations do not generate extra
> semicolons. It's already needed for enumerations and static inline functions
> declarations, but not documented, so document it here.

I think you need to have two patch sets. One to do the semicolon clean
up, and one for the preparation of arrays. Again, the semi-colon cleanup
I'm fine with keeping even if we don't do the arrays. But this is only
needed if we do the array work.

I'm not even sure I want to do it this way. I may change it when I do
the array work.

-- Steve


