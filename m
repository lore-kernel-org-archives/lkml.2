Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1GUONw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:13:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43491 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1GUONt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:13:49 -0400
Subject: Re: [tip:perf/core] perf: Remove the nmi parameter from the
 swevent and overflow interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "dengcheng.zhu@gmail.com" <dengcheng.zhu@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "anton@samba.org" <anton@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "emunson@mgebm.net" <emunson@mgebm.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcree@orcon.net.nz" <mcree@orcon.net.nz>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20110721141027.GA8446@e102144-lin.cambridge.arm.com>
References: <tip-agjev8eu666tvknpb3iaj0fg@git.kernel.org>
	 <20110708173442.GB31972@e102144-lin.cambridge.arm.com>
	 <1310146876.3282.711.camel@twins>
	 <20110721141027.GA8446@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jul 2011 16:13:00 +0200
Message-ID: <1311257580.29152.148.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 15:10 +0100, Will Deacon wrote:

> > > diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> > > index 59acf9e..94796f3 100644
> > > --- a/drivers/oprofile/oprofile_perf.c
> > > +++ b/drivers/oprofile/oprofile_perf.c
> > > @@ -31,7 +31,7 @@ static int num_counters;
> > >  /*
> > >   * Overflow callback for oprofile.
> > >   */
> > > -static void op_overflow_handler(struct perf_event *event, int unused,
> > > +static void op_overflow_handler(struct perf_event *event,
> > >                         struct perf_sample_data *data, struct pt_regs *regs)
> > >  {
> > >         int id;
> > > 
> > 
> > Yes, that is sufficient. Thanks!
> 
> I can't see this in next. Are you happy taking this or do you want me to
> post it to the list as a standalone patch?

I just handed it to Ingo (who's back from vacation), it should show up
today or tomorrow.
