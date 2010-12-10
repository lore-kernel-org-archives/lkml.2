Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab0LJLCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:02:05 -0500
Received: from www.tglx.de ([62.245.132.106]:35943 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0LJLCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:02:03 -0500
Date: Fri, 10 Dec 2010 12:01:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
cc: "'Tejun Heo'" <tj@kernel.org>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCHv1 000/211] unicore32 architecture support
In-Reply-To: <026901cb9848$17e71ac0$47b55040$@mprc.pku.edu.cn>
Message-ID: <alpine.LFD.2.00.1012101156230.2653@localhost6.localdomain6>
References: <01ca01cb9783$7818c3f0$684a4bd0$@mprc.pku.edu.cn> <4D00A672.9050906@kernel.org> <alpine.LFD.2.00.1012091443580.2653@localhost6.localdomain6> <026901cb9848$17e71ac0$47b55040$@mprc.pku.edu.cn>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Guan Xuetao wrote:
> 
> > -----Original Message-----
> > From: linux-arch-owner@vger.kernel.org [mailto:linux-arch-
> > owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> > Sent: Thursday, December 09, 2010 9:50 PM
> > To: Tejun Heo
> > Cc: Guan Xuetao; Arnd Bergmann; linux-arch@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCHv1 000/211] unicore32 architecture support

Please fix your mail client to do proper citations. A single line 

On Thu, 9 Dec 2010, Thomas Gleixner wrote:

or whatever your preferred cite line is, is sufficient. We all have
the mail header already.
 
> > It's ok to have several patches ordered by topics
> > 
> >   - generic header stuff
> >   - processor and system headers
> >   - low level entry and setup code
> >   - process/thread related code
> >   - mm related code
> >   - timers
> >   - interrupts
> >   - ptrace
> >   - signals
> >   - fault handling
> >   - misc
> >   - build system, main makefile, Kconfig
> > 
> > That makes it actually feasible to review.
> Thanks,
> I will rearrange my patches.

And please mail them to yourself before you post them and make sure
they apply and resemble exaclty what you wanted to send. I just
noticed, that your mailer line-wrapped the patches:

+       /*
+        * actually the registers should be pushed and pop'd conditionally,
but
+        * after bl the flags are certainly clobbered
+        */

Thanks,

	tglx
