Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936192Ab2KAXCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 19:02:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:35644 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936148Ab2KAXCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 19:02:03 -0400
Date: Fri, 2 Nov 2012 00:01:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter LaDow <petela@gocougs.wsu.edu>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RT 3/4] net: netfilter: Serialize xt_write_recseq sections
 on RT
In-Reply-To: <CAN8Q1Ecq9T5HC60_ta8Xr9kKyAe8Fjrd8znV9MpDTYqkSSptOw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211012358280.2756@ionos>
References: <20121031003258.811955127@goodmis.org> <20121031003314.763160265@goodmis.org> <CAN8Q1EcVfzJJh+XMeXMMk33kwyyyRoEWsuEbSQqVW0Vz3i3Vuw@mail.gmail.com> <alpine.LFD.2.02.1211012213460.2756@ionos>
 <CAN8Q1Ecq9T5HC60_ta8Xr9kKyAe8Fjrd8znV9MpDTYqkSSptOw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Peter LaDow wrote:

> On Thu, Nov 1, 2012 at 2:26 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Cough. You are missing a boat load of crucial fixes. There is a damned
> > good reason why 3.0.stable got 12 updates and the -rt version 14.
> 
> I don't doubt there are.  But we've only experienced one problem
> between 3.0.36-rt58 and 3.0.48-rt72.  Indeed, it might be easier to
> evaluate the risk if all the changelogs were readily available.  So
> far, however, we haven't discovered any other issues that give us any
> concerns.
> 
> > Your risk assessment is definitley interesting.
> 
> We have specifically tested 3.0.36-rt58 for performance in our
> application.  Moving to 3.0.48-rt72 poses risk about whether would
> still be able to meet our performance requirements.  And with regard
> to stability, the only issue we've had since our earlier moved to
> 3.0.36-rt58 was the netfilter problem.  We initially only saw the
> problem on PPP related interfaces, so we reverted to 3.0.3 (non-rt)
> for PPP related issues.
> 
> Now, if you think there are some issues that should raise eyebrows, or
> can point me to a list of changelogs, I'd be happy to evaluate them.

git log v3.0.36-rt58..3.0.48-rt72

That's what a source version control system is designed for AFAICT

Thanks,

	tglx
