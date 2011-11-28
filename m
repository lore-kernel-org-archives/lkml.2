Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1K1UNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:13:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1K1UNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:13:12 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=jMOZBfb3lLUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=fnc64qcN2j_nGbhq2D8A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 7/9] ftrace, perf: Add support to use function
 tracepoint in perf
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        paulus@samba.org, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <1322510636.2921.168.camel@twins>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
	 <1322417074-5834-8-git-send-email-jolsa@redhat.com>
	 <1322510318.17003.14.camel@frodo>  <1322510636.2921.168.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 15:13:09 -0500
Message-ID: <1322511189.17003.22.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 21:03 +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-28 at 14:58 -0500, Steven Rostedt wrote:
> > >   perf stat -e ftrace:function ls
> > 
> > Question. This is a root only command, correct? Otherwise, we are
> > allowing any user to create a large performance impact to the system. 
> 
> Typically not, although I haven't looked at Jiri's implementation of the
> function tracepoint.
> 

I would not allow function tracing for non root users. It's just way too
invasive to let such a thing happen.

-- Steve



