Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1GDApf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 20:45:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:58334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab1GDApe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 20:45:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,469,1304319600"; 
   d="scan'208";a="25866558"
Subject: Re: power increase issue on light load
From: "Alex,Shi" <alex.shi@intel.com>
To: Nikhil Rao <ncrao@google.com>
Cc: Ming Lei <tom.leiming@gmail.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAOM-RdN3cweRQnNxCaCGuyj2GMojix15XG5MVj8pxj7FHX79hg@mail.gmail.com>
References: <1308797024.23204.95.camel@debian>
	 <BANLkTimEcPmH_XgLy5aEW+znwJyVZzfoCg@mail.gmail.com>
	 <CAOM-RdN3cweRQnNxCaCGuyj2GMojix15XG5MVj8pxj7FHX79hg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 08:45:27 +0800
Message-ID: <1309740327.567.46.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 02:00 +0800, Nikhil Rao wrote:
> Hi Ming,
> 
> On Thu, Jun 30, 2011 at 10:44 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> > Hi,
> >
> > On Thu, Jun 23, 2011 at 10:43 AM, Alex,Shi <alex.shi@intel.com> wrote:
> >> commit c8b281161dfa4bb5d5be63fb036ce19347b88c63 causes light load
> >> benchmark use more than 10% system power on platform NHM-EP and laptop
> >> Thinkpad T410 etc. The benchmarks are specpower and bltk office.
> >>
> >> I tried to track this issue, but only find deep C sate time reduced
> >> much, about from 90% to 30~40%, the C0 or C1 state increase much on
> >> different machines.
> >>
> >> Powertop just hints RES interrupts has a bit more. but when I try "perf
> >> probe native_smp_send_reschedule". I didn't find much.
> >
> > I see the problem on -rc5 in my T410 too, the fan has been ringing always
> > and powertop reports "Wakeups-from-idle per second : 508.6".
> >
> 
> Thanks for reporting this issue. Looks like the increased resolution
> has a negative impact on power savings balance. I'm looking into this
> issue based on Alex's data, but If you can give a trace or something
> that I can work with it will be really helpful.

Ops, I didn't aware that my evolution didn't send out the trace code to
you, until this e-mail. I just resend them and it should be OK this
time. Please check it and give me a response. 
Thanks!

> 
> -Thanks,
> Nikhil


