Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1BJMYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:24:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54069 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1BJMYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:24:32 -0500
Date: Thu, 10 Feb 2011 13:24:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Rothwell <sfr@au1.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen-two tree with the tip tree
Message-ID: <20110210122423.GC26094@elte.hu>
References: <20110210145528.95c90b63.sfr@au1.ibm.com>
 <alpine.LFD.2.00.1102101319440.31804@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102101319440.31804@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> 
> 
> On Thu, 10 Feb 2011, Stephen Rothwell wrote:
> 
> > Hi Konrad,
> > 
> > Today's linux-next merge of the xen-two tree got a conflict in
> > kernel/irq/manage.c between commit
> > dc5f219e88294b93009eef946251251ffffb6d60 ("genirq: Add
> > IRQF_FORCE_RESUME") from the tip tree and commit
> > c6c5596743c2a333a8e31b0247f44cd367484a5e ("genirq: Add
> > IRQF_FORCE_RESUME") from the xen-two tree.
> > 
> > Despite having the same Author time stamps, these commits are not quite the
> > same.  I used the version from the tip tree which kept the line:
> > 
> > 		desc->status &= ~IRQ_SUSPENDED;
> 
> That's the correct one. I fear I messed up, when I gave xen folks the
> git url to pull from. I had the first version pushed out, and zapped
> right away when I noticed the missing line. Then fixed it and
> repushed. I should have checked git://..... which obviously had
> already picked up the borked one and did not pick up the correct one
> before xen folks pulled. Sorry about that.

The resolution would be for the Xen tree to pull again and pick the new commit's 
content as the conflict resolution result. That will resolve the linux-next conflict 
as well.

Thanks,

	Ingo
