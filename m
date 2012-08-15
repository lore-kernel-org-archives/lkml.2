Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2HOOrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:47:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:37521 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2HOOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:47:32 -0400
Date: Wed, 15 Aug 2012 16:47:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Arjan van de Ven <arjan@linux.intel.com>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
In-Reply-To: <1345041897.31459.95.camel@twins>
Message-ID: <alpine.LFD.2.02.1208151646430.32033@ionos>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>  <502BB000.60502@linux.intel.com> <1345041897.31459.95.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Peter Zijlstra wrote:

> On Wed, 2012-08-15 at 07:19 -0700, Arjan van de Ven wrote:
> > Ideally the scheduler builds up some history of the typical run
> > duration of the task (with a bias to more recent runs).
> > But... even then, the past is only a poor predictor for the future. 
> 
> PJTs patches do this. But yes, a crystal-ball instruction which
> completes in a single cycle would be most appreciated :-)

You could ask the S390 folks whether they could whip one up for proof
of concept. :)

