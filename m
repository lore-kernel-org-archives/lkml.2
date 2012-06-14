Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2FNKvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:51:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61325 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2FNKvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:51:36 -0400
Date: Thu, 14 Jun 2012 12:51:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        kiran.thirumalai@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, Fengguang Wu <wfg@linux.intel.com>
Subject: Re: [tip:x86/platform] x86/vsmp: Ignore IOAPIC IRQ affinity if
 possible
Message-ID: <20120614105130.GB8683@gmail.com>
References: <1338675095-27260-2-git-send-email-ido@wizery.com>
 <tip-3aabb53ce5849605cee731bbc32f37120b4c4ceb@git.kernel.org>
 <20120608085229.GA10638@gmail.com>
 <20120608154301.GA11242@NoteStation>
 <20120611085843.GL31556@gmail.com>
 <20120611194117.GA19302@NoteStation.sbx07338.cambrma.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611194117.GA19302@NoteStation.sbx07338.cambrma.wayport.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> Hi Ingo,
> 
> On Mon, Jun 11, 2012 at 10:58:43AM +0200, Ingo Molnar wrote:
> > 
> > * Ido Yariv <ido@wizery.com> wrote:
> > 
> > > This seems to break when CONFIG_PARAVIRT is set but CONFIG_SMP 
> > > isn't. Since there's little point in optimizing IOAPIC routing 
> > > for UP kernels, how about the following fix?
> > 
> > Looks good to me, I'll give it some testing.
> 
> I'm afraid this patch is missing one more config dependency. Since
> no_irq_affinity is declared in proc.c, we need to verify that
> CONFIG_PROC_FS is set before referencing this variable. The below patch
> fixes this.
> 
> Thanks to Fengguang Wu for reporting this.

Please send a delta fix patch on top of latest -tip to fix this.

Thanks,

	Ingo
