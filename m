Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1CBJzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:55:32 -0500
Received: from www.tglx.de ([62.245.132.106]:53921 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433Ab1CBJzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:55:31 -0500
Date: Wed, 2 Mar 2011 10:55:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, amit.kucheria@linaro.org,
        mingo@elte.hu, rusty@rustcorp.com.au
Subject: Re: [PATCH V6 2/2] tracing, perf: add cpu hotplug trace events
In-Reply-To: <AANLkTikzfNsB=9jQSYrWDEYd3Kd1-d8cVMO79ZqDNt4n@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103021053480.2701@localhost6.localdomain6>
References: <AANLkTi=WRo41JprvcEH0Lgc_-j_bTX1MULgJFShV6W9g@mail.gmail.com> <alpine.LFD.2.00.1103021033260.2701@localhost6.localdomain6> <AANLkTikzfNsB=9jQSYrWDEYd3Kd1-d8cVMO79ZqDNt4n@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1486651609-1299059712=:2701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1486651609-1299059712=:2701
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 2 Mar 2011, Vincent Guittot wrote:

> On 2 March 2011 10:38, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 1 Mar 2011, Vincent Guittot wrote:
> >
> >> Trace the cpu state and the time spent in core and arch code
> >
> > So you completely ignored my review comments, except for fixing up the
> > changelog.
> >
> >        https://lkml.org/lkml/2011/2/24/297
> >
> > All of the comments in the code still apply and either you fix it or
> > at least have the courtesy to explain why you think that those
> > comments do not need to be addressed.
> >
> 
> I thought that I have answered to your comments :
> https://lkml.org/lkml/2011/2/28/203
> 
> Do I miss something ?

Oops, my bad. I missed that reply somehow. It's not in my inbox. Will
dig into my lkml archive then.

Thanks,

	tglx


---1463795968-1486651609-1299059712=:2701--
