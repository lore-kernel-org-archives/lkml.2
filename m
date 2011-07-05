Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1GEMv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:51:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:56064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab1GEMv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:51:26 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=PKUarE_T-c8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7mOBRU54AAAA:8 a=CHiZ6g6q5NVKZL7A0iQA:9 a=PUjeQqilurYA:10 a=WeOa-AV5lc8A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [patch 03/11] blackfin/irqs: Do not trace arch_local_{*,irq_*}
 functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <CAMjpGUd2rqVSXVvRYbXW_-ah-91pYntKGxwrjXKqBeN27QUVLQ@mail.gmail.com>
References: <20110702030435.308336775@goodmis.org>
	 <20110702033853.220897627@goodmis.org>
	 <CAMjpGUd2rqVSXVvRYbXW_-ah-91pYntKGxwrjXKqBeN27QUVLQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jul 2011 08:51:24 -0400
Message-ID: <1309870284.26417.172.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 12:40 -0400, Mike Frysinger wrote:
> On Fri, Jul 1, 2011 at 23:04, Steven Rostedt wrote:
> > Do not trace arch_local_save_flags(), arch_local_irq_*() and friends.
> > Although they are marked inline, gcc may still make a function out of
> > them and add it to the pool of functions that are traced by the function
> > tracer. This can cause undesirable results (kernel panic, triple faults,
> > etc).
> >
> > Add the notrace notation to prevent them from ever being traced.
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>

Thanks! Are you going to pull it into the blackfin tree? It's not
dependent on any other patch.

-- Steve


