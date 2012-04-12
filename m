Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2DLATO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:19:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11646 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2DLATM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:19:12 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=j20LOcyRnVUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=CVkhZaI7AAAA:8 a=uw-SByA7DZ5U6DKFYowA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334189948.23924.313.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 08/16] sched: add period support for -deadline tasks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, cfriesen@nortel.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Date: Wed, 11 Apr 2012 20:19:08 -0400
In-Reply-To: <4F8601EE.90905@sssup.it>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-9-git-send-email-juri.lelli@gmail.com>
	 <1334176337.23924.297.camel@gandalf.stny.rr.com> <4F8601EE.90905@sssup.it>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 23:13 +0100, Tommaso Cucinotta wrote:

> For a formal proof, I think you can refer to the Abeni's paper(s):
> 
> -) Integrating Multimedia Applications in Hard Real-Time Systems, RTSS '98
>      www.cis.upenn.edu/~lee/01cis642/papers/AB98.pdf
> 
> which redirects on the Technical Report:
> -) Server Mechanisms for Multimedia Applications
> 
> Hope this helps,

Thanks, I'll read up on it. Honestly, it's been 5 years since I worked
with rate monotonic algorithms. I'm happy to get back into it ;-)

-- Steve


