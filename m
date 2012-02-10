Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab2BJSAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:00:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373Ab2BJSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:00:18 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=eSfxnIkts4oA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=HhXWdawGNUOR4R1HoecA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328896815.8273.8.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv8 0/8] ftrace, perf: Adding support to use function trace
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Fri, 10 Feb 2012 13:00:15 -0500
In-Reply-To: <20120210164837.GC25516@somewhere.redhat.com>
References: <1327776209-4883-1-git-send-email-jolsa@redhat.com>
	 <1328643899-8361-1-git-send-email-jolsa@redhat.com>
	 <1328880444.8273.3.camel@gandalf.stny.rr.com>
	 <1328885120.8273.7.camel@gandalf.stny.rr.com>
	 <20120210160756.GB6145@m.redhat.com>
	 <20120210164837.GC25516@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 17:48 +0100, Frederic Weisbecker wrote:

> Stephane Eranian has reported a similar problem but perhaps not with
> the same cause.
> 
> I need to have a look.

Not sure if this is related, but the "script" output of the problem
perf.dat file had this warning:

Warning: Timestamp below last timeslice flush

-- Steve


