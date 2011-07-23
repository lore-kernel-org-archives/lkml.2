Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab1GWKrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 06:47:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:53135 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1GWKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 06:47:03 -0400
Date: Sat, 23 Jul 2011 12:47:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Rolando Martins <rolando.martins@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval_giani@gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt1
In-Reply-To: <1311417889.5549.0.camel@twins>
Message-ID: <alpine.LFD.2.02.1107231246470.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>  <CABcS5h01jpOSKcKtrJ65AqNNQDCAOutQADAE_pcRp-MPBoO-VA@mail.gmail.com>  <alpine.LFD.2.02.1107230930330.2702@ionos>  <CABcS5h2EMMsKPw7DcQ9XdUKamOe3m4CN1A3hwRyPkfpAMO4Orw@mail.gmail.com> 
 <alpine.LFD.2.02.1107231202050.2702@ionos> <1311417889.5549.0.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jul 2011, Peter Zijlstra wrote:

> On Sat, 2011-07-23 at 12:20 +0200, Thomas Gleixner wrote:
> > On Sat, 23 Jul 2011, Rolando Martins wrote:
> > > Hi Thomas,
> > > 
> > > Do you see it being fixed in a near future?
> > 
> > Delegating that question to scheduler wizards and folks you created
> > that mess in the first place.
> 
> Uhm what?

RT_GROUP_SCHED & RT 
