Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007Ab0LNKHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:07:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34724 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758283Ab0LNKHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:07:31 -0500
X-Authenticated: #18899812
X-Provags-ID: V01U2FsdGVkX19jZP9y9PdjHMQkeRPP5E1dBw3Iu5FwIaJ7HKifRr
	phKOkonxkVlkPi
Subject: Re: Scheduler grouping failure; division by zero in
 select_task_rq_fair
From: Frede Feuerstein <Frede_Feuerstein@gmx.net>
Reply-To: Frede_Feuerstein@gmx.net
To: Ingo Molnar <mingo@elte.hu>
Cc: Ben Hutchings <ben@decadent.org.uk>, Peter Zijlstra <peterz@infradead.org>,
        603229@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20101129180605.GC14046@elte.hu>
References: <1290449310.3868.13.camel@localhost>
	 <1290470134.6770.929.camel@localhost> <1290514638.3892.16.camel@localhost>
	 <1290900814.3292.84.camel@localhost> <1290920436.4255.1025.camel@localhost>
	 <1290975266.3292.316.camel@localhost> <1291031425.32004.16.camel@laptop>
	 <20101129162605.GH8695@decadent.org.uk>  <20101129180605.GC14046@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: =?ISO-8859-1?Q?Ger=F6llhalde?=
Date: Tue, 14 Dec 2010 11:07:21 +0100
Message-ID: <1292321241.4511.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

> We definitely want to robustify scheduler init code to not crash and to (if 
> possible) print a warning about the borkage.

I just tested the last 2.6.32-5 update and it still crashes in the same
manner.

Best regards
Tilo Hacke

