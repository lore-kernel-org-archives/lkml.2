Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2DPT40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:56:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29157 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2DPT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:56:25 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=qYvamlIpaesA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=dblkIPm9v_dBaoDoiroA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334606180.28106.7.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 11/16] sched: add latency tracing for -deadline tasks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Vacek <neelx.g@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        raistlin@linux.it
Date: Mon, 16 Apr 2012 15:56:20 -0400
In-Reply-To: <CAA7rmPGcnXhPUWLWCUS7spy3Grv=aE1Mng=DfD=XM7-GNDyX_w@mail.gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-12-git-send-email-juri.lelli@gmail.com>
	 <1334178222.23924.304.camel@gandalf.stny.rr.com>
	 <CAA7rmPGcnXhPUWLWCUS7spy3Grv=aE1Mng=DfD=XM7-GNDyX_w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 17:51 +0200, Daniel Vacek wrote:

> sorry for the question, I'm obviously missing something here but what
> is the logic behind this rewrite? In both cases my gcc generates the
> same code for me.

Yeah, I noticed that later. I thought it was doing something slightly
different, but after a good nights rest, and re-reading what I wrote in
the morning, it was obviously the same functionality.

But that said. The final result is much easier to read. And as you
stated, it doesn't make a difference in the final outcome, it ended up
being a good fix (more readable code means less bugs).

-- Steve


