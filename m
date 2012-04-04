Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2DDG4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 02:56:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61879 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2DDG4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 02:56:24 -0400
Date: Wed, 4 Apr 2012 08:56:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20120404065619.GA8632@gmail.com>
References: <20120403224529.GA5593@gmail.com>
 <20120403234702.GD6132@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403234702.GD6132@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Wed, Apr 04, 2012 at 12:45:29AM +0200, Ingo Molnar wrote:
> > Linus,
> > 
> > Please pull the latest x86-urgent-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus
> 
> Hey Ingo,
> 
> I was wondering what happend to the two patches to fix the 
> regression introduced by Suresh's patch (the "x86, ioapic: add 
> register checks for bogus io-apic entries")?

That's really a Xen bug (if real hw behaves well then Xen can 
behave well too, right?) - I suggest you should work it around 
in Xen first - I wanted to wait with applying more invasive 
ioapic changes, that's probably v3.5 material anyway. The 
patches arrived in the middle of the merge window.

Thanks,

	Ingo
