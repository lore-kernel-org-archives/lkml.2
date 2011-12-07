Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab1LGTnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:43:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603Ab1LGTnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:43:00 -0500
Date: Wed, 7 Dec 2011 14:42:52 -0500
From: Don Zickus <dzickus@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 7 (x86, not SMP)
Message-ID: <20111207194252.GH1669@redhat.com>
References: <20111207171218.e11db78531e7f20659e2ca65@canb.auug.org.au>
 <4EDFBA25.1020102@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDFBA25.1020102@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 11:10:29AM -0800, Randy Dunlap wrote:
> On 12/06/2011 10:12 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111206:
> 
> 
> When CONFIG_SMP is not enabled:
> (I think that's the cause, but it could be some other kconfig option.)

Yeah it doesn't seem to be that one.  I think it is CONFIG_X86_LOCAL_APIC,
but I can't quickly figure out how to disable it (it keeps getting
re-enabled somewhere).

Can you attach your .config?

Thanks,
Don

> 
> 
> arch/x86/built-in.o: In function `test_nmi_ipi':
> nmi_selftest.c:(.text+0xf7a0): undefined reference to `apic'
> 
> -- 
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
