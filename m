Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2DXBEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:04:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11573 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2DXBEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:04:02 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=unLN5eZtZcEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=BuleduMwnqcLhVulvM8A:9 a=elNPHhPqOPENFrO53C4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335229437.28106.131.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Date: Mon, 23 Apr 2012 21:03:57 -0400
In-Reply-To: <1335218328.28150.181.camel@twins>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	 <1335182113.28150.132.camel@twins> <4F95CFBF.1050000@sssup.it>
	 <1335218328.28150.181.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 23:58 +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 22:55 +0100, Tommaso Cucinotta wrote:
> > why not write this straight in asm, i.e., multiply 64*64 then divide by 
> > 64 keeping the intermediate result on 128 bits? 
> 
> If you know of a way to do this for all 30 odd architectures supported
> by our beloved kernel, do let me know ;-)
> 
> Yes I can do it for x86_64, but people tend to get mighty upset if you
> break the compile for all other arches...

Use the draconian method. Make SCHED_DEADLINE dependent on
"ARCH_HAS_128_MULT" and any arch maintainer that wants SCHED_DEADLINE
for their arch will be responsible for implementing it ;-)

-- Steve


