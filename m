Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab1BJMWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:22:54 -0500
Received: from www.tglx.de ([62.245.132.106]:34617 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1BJMWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:22:52 -0500
Date: Thu, 10 Feb 2011 13:22:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@au1.ibm.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen-two tree with the tip tree
In-Reply-To: <20110210145528.95c90b63.sfr@au1.ibm.com>
Message-ID: <alpine.LFD.2.00.1102101319440.31804@localhost6.localdomain6>
References: <20110210145528.95c90b63.sfr@au1.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Feb 2011, Stephen Rothwell wrote:

> Hi Konrad,
> 
> Today's linux-next merge of the xen-two tree got a conflict in
> kernel/irq/manage.c between commit
> dc5f219e88294b93009eef946251251ffffb6d60 ("genirq: Add
> IRQF_FORCE_RESUME") from the tip tree and commit
> c6c5596743c2a333a8e31b0247f44cd367484a5e ("genirq: Add
> IRQF_FORCE_RESUME") from the xen-two tree.
> 
> Despite having the same Author time stamps, these commits are not quite the
> same.  I used the version from the tip tree which kept the line:
> 
> 		desc->status &= ~IRQ_SUSPENDED;

That's the correct one. I fear I messed up, when I gave xen folks the
git url to pull from. I had the first version pushed out, and zapped
right away when I noticed the missing line. Then fixed it and
repushed. I should have checked git://..... which obviously had
already picked up the borked one and did not pick up the correct one
before xen folks pulled. Sorry about that.

Thanks,

	tglx
