Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0DNTfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 15:35:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab0DNTfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 15:35:03 -0400
Date: Wed, 14 Apr 2010 15:34:19 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Subject: Re: [PATCH 0/9] jump label v6
Message-ID: <20100414193419.GC2747@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com> <20100413165659.GA23931@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413165659.GA23931@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 12:56:59PM -0400, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > Hi,
> > 
> > Refresh of jump labeling patches aginst -tip tree. For bacground see: 
> > http://marc.info/?l=linux-kernel&m=125858436505941&w=2
> > 
> > I believe I've addressed all the reviews from v5.
> 
> Hi Jason,
> 
> I would appreciate if you could add pointers to the Immediate Values
> benchmarks (or possibly some benchmark information altogether) and a
> notice that some parts of the design are inspired from Immediate Values
> in the jump label code.
> 
> I recognise that you did great work on getting jump label in shape both
> at the Linux kernel and gcc level, but it's usually appropriate to
> acknowledge prior work it is based on. Only then can I justify that
> Immediate Values have been useful in the whole process.
> 

So I've been doing micro-benchmarks measuring the cycles involved when
the tracepoints are disabled. As quoted from the above pointer:

"As discussed in pervious mails I've seen an average improvement of 30
cycles per-tracepoint on x86_64 systems that I've tested."

I can post my test harness if you are interested.

If there are any other benchmarks of interest please let me know.

I am planning to add a Docmentation/ file for jump labels, so I can add
about the previous Immediate value work, which certainly has been
useful.

thanks,

-Jason

