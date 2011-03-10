Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1CJRHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:07:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59189 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1CJRHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:07:11 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=s7jom2g7sBwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3O4C1wECQaRswuDFdWwA:9 a=NUjL7gliyCi_kv3Xub6QrPmqYYYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/6] perf script: move printing of 'common' data from
 print_event and rename
From: Steven Rostedt <rostedt@goodmis.org>
To: David Ahern <daahern@cisco.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
In-Reply-To: <4D790038.502@cisco.com>
References: <1299734608-5223-1-git-send-email-daahern@cisco.com>
	 <1299734608-5223-4-git-send-email-daahern@cisco.com>
	 <20110310152053.GB12521@home.goodmis.org>
	 <20110310155109.GB23555@ghostprotocols.net>
	 <1299773135.15854.352.camel@gandalf.stny.rr.com>
	 <20110310162038.GC23555@ghostprotocols.net>  <4D790038.502@cisco.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 12:07:08 -0500
Message-ID: <1299776828.15854.353.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 09:45 -0700, David Ahern wrote:
> 
> On 03/10/11 09:20, Arnaldo Carvalho de Melo wrote:
> >>> I think the merge with the libraries you mention is something that is
> >>> not a precondition to merging David's work.
> >>>
> >>> And his work is at least moving things in the trace parts of tools/,
> >>> that was so far dormant.
> >>
> >> Note, I'm not saying that his work should be put on hold. I actually
> >> want to start it up again. Maybe I worded this response wrong. It was
> >> more about bringing David up to speed on what I want to do next than
> >> saying not to do this work.
> > 
> > Right, I just wanted to make sure he doesn't spill his coffee with what
> > could seem like yet another requirement to work on infrastructure to get
> > his legitimate feature implementation merged :-)
> 
> I appreciate the clarification. Luckily, no coffee in hand.
> 
> I need to get the time-of-day strings done next, and someone else is
> pushing the reverse callchain display (another local change I wanted to
> get upstream). I could take a look at other requests - like common code
> - as time allows.

Right, we could start looking at making the common code on top of your
changes. I don't want to hinder progress for asking for too much.

Thanks,

-- Steve


