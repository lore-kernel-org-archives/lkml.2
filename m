Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab0IUSQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 14:16:17 -0400
Received: from www.tglx.de ([62.245.132.106]:37762 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384Ab0IUSQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 14:16:16 -0400
Date: Tue, 21 Sep 2010 20:15:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Udo van den Heuvel <udovdh@xs4all.nl>, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, venkatesh.pallipadi@intel.com, markh@compro.net,
        linux-kernel@vger.kernel.org
Subject: Re: Fwd: patch: HPET force enable for CX700 / VIA Epia LT was: Re:
 hpet timers gone?
In-Reply-To: <20100921163811.GC21459@dumpdata.com>
Message-ID: <alpine.LFD.2.00.1009212009050.2416@localhost6.localdomain6>
References: <4C90C829.2080005@xs4all.nl> <20100921163811.GC21459@dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Tue, 21 Sep 2010, Konrad Rzeszutek Wilk wrote:

> On Wed, Sep 15, 2010 at 03:20:41PM +0200, Udo van den Heuvel wrote:
> > Hello,
> > 
> > Who can help me get this minor patch into the kernel?
> 
> You need to CC these folks:
> konrad@phenom:~/work/linux$ scripts/get_maintainer.pl -f arch/x86/kernel/quirks.c 
> Thomas Gleixner <tglx@linutronix.de>
> Ingo Molnar <mingo@redhat.com>
> H. Peter Anvin <hpa@zytor.com>
> x86@kernel.org
> Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Mark Hounschell <markh@compro.net>
> linux-kernel@vger.kernel.org
> 
> Which I just did on your e-mail.

6 days too late. See:

http://www.gossamer-threads.com/lists/linux/kernel/1276240

It's queued for 2.6.37

Thanks,

	tglx
