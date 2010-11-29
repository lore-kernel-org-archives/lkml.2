Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0K2N6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:58:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50053 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754177Ab0K2N6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:58:18 -0500
X-Authenticated: #18899812
X-Provags-ID: V01U2FsdGVkX188CVpqt8E8rRUp8UWt/sKsJ8lJlbAkvAvkFDborH
	Xzf4BewO5iaG1d
Subject: Re: Scheduler grouping failure; division by zero in
 select_task_rq_fair
From: Frede Feuerstein <Frede_Feuerstein@gmx.net>
Reply-To: Frede_Feuerstein@gmx.net
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ben Hutchings <benh@debian.org>, Ingo Molnar <mingo@elte.hu>,
        603229@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <1291031425.32004.16.camel@laptop>
References: <1290449310.3868.13.camel@localhost>
	 <1290470134.6770.929.camel@localhost>  <1290514638.3892.16.camel@localhost>
	 <1290900814.3292.84.camel@localhost> <1290920436.4255.1025.camel@localhost>
	 <1290975266.3292.316.camel@localhost>  <1291031425.32004.16.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: =?ISO-8859-1?Q?Ger=F6llhalde?=
Date: Mon, 29 Nov 2010 14:58:13 +0100
Message-ID: <1291039093.26937.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 12:50 +0100, Peter Zijlstra wrote:
> On Sun, 2010-11-28 at 20:14 +0000, Ben Hutchings wrote:
> 
> > [    0.856002] Pid: 2, comm: kthreadd Not tainted 2.6.32-5-amd64 #1 W1100z/2100z
> 
> What's in that kernel? is that simply the latest .32-stable?

It was the latest stable .32 contained in the official "squeeze".
Today a new one arrived. I shall try that tomorrow on today late night,
since i cannot reset the mill right now.

Additional remark:
When i said, that the cores contained in each chip do not share any
resources, i forgot about the clock source:
The clock is set globally for each whole chip, i.e. CPU0 and CPU1 are
always running on the same clock, as well as CPU2 and CPU3 do.

Best regards

Tilo Hacke


