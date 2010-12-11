Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab0LKAMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 19:12:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab0LKAMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 19:12:18 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=sDWRAbKr6x0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=k_nDliN21-a9Jn1-6ZsA:9 a=t-FeMXg3OPh0QZU8SBQA:7 a=dQJkbN6Gwj5jT63V4f_vc5_sw6wA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 03/10] workqueue: It is likely that
 WORKER_NOT_RUNNING is true
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D02C14E.80001@kernel.org>
References: <20101207015834.196176991@goodmis.org>
	 <20101207021328.847976021@goodmis.org>  <4CFE0346.6090904@kernel.org>
	 <1292026104.5015.1540.camel@gandalf.stny.rr.com>
	 <4D02C14E.80001@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 10 Dec 2010 19:12:17 -0500
Message-ID: <1292026337.5015.1542.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-11 at 01:09 +0100, Tejun Heo wrote:
> On 12/11/2010 01:08 AM, Steven Rostedt wrote:
> > On Tue, 2010-12-07 at 10:49 +0100, Tejun Heo wrote:
> > 
> >> Yeah, I was lost thinking about the busiest case where workers are
> >> busy processing works consecutively.  Usually workers are of course
> >> switching in and out of idle state all the time.
> >>
> >> How about just dropping likely/unlikely?
> > 
> > OK, if I just remove it, can I add your Acked-by?
> 
> Sure, then, I'll route it through my tree.


OK, I'll post a new patch series again. Just pluck it from that, and let
me know so I can remove it from my tree.

Thanks,

-- Steve


