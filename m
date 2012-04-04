Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2DDNIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 09:08:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18300 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2DDNIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 09:08:35 -0400
Date: Wed, 4 Apr 2012 09:03:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20120404130342.GE6132@phenom.dumpdata.com>
References: <20120403224529.GA5593@gmail.com>
 <20120403234702.GD6132@phenom.dumpdata.com>
 <20120404065619.GA8632@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404065619.GA8632@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F7C47C8.00CD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 08:56:19AM +0200, Ingo Molnar wrote:
> 
> * Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Wed, Apr 04, 2012 at 12:45:29AM +0200, Ingo Molnar wrote:
> > > Linus,
> > > 
> > > Please pull the latest x86-urgent-for-linus git tree from:
> > > 
> > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus
> > 
> > Hey Ingo,
> > 
> > I was wondering what happend to the two patches to fix the 
> > regression introduced by Suresh's patch (the "x86, ioapic: add 
> > register checks for bogus io-apic entries")?
> 
> That's really a Xen bug (if real hw behaves well then Xen can 
> behave well too, right?) - I suggest you should work it around 
> in Xen first - I wanted to wait with applying more invasive 
> ioapic changes, that's probably v3.5 material anyway. The 
> patches arrived in the middle of the merge window.

Ok.
