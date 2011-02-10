Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1BJP1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:27:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:18005 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1BJP1Q (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Feb 2011 10:27:16 -0500
Date: Thu, 10 Feb 2011 10:24:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@au1.ibm.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the xen-two tree with the tip tree
Message-ID: <20110210152457.GB12087@dumpdata.com>
References: <20110210145528.95c90b63.sfr@au1.ibm.com>
 <alpine.LFD.2.00.1102101319440.31804@localhost6.localdomain6>
 <20110210122423.GC26094@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210122423.GC26094@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D5403A2.0208:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:24:23PM +0100, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > 
> > 
> > On Thu, 10 Feb 2011, Stephen Rothwell wrote:
> > 
> > > Hi Konrad,
> > > 
> > > Today's linux-next merge of the xen-two tree got a conflict in
> > > kernel/irq/manage.c between commit
> > > dc5f219e88294b93009eef946251251ffffb6d60 ("genirq: Add
> > > IRQF_FORCE_RESUME") from the tip tree and commit
> > > c6c5596743c2a333a8e31b0247f44cd367484a5e ("genirq: Add
> > > IRQF_FORCE_RESUME") from the xen-two tree.
> > > 
> > > Despite having the same Author time stamps, these commits are not quite the
> > > same.  I used the version from the tip tree which kept the line:
> > > 
> > > 		desc->status &= ~IRQ_SUSPENDED;
> > 
> > That's the correct one. I fear I messed up, when I gave xen folks the
> > git url to pull from. I had the first version pushed out, and zapped
> > right away when I noticed the missing line. Then fixed it and
> > repushed. I should have checked git://..... which obviously had
> > already picked up the borked one and did not pick up the correct one
> > before xen folks pulled. Sorry about that.
> 
> The resolution would be for the Xen tree to pull again and pick the new commit's 
> content as the conflict resolution result. That will resolve the linux-next conflict 
> as well.

Should be all fixed now.
