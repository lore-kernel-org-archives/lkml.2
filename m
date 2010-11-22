Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0KVWA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 17:00:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128Ab0KVWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 17:00:58 -0500
Date: Mon, 22 Nov 2010 17:00:40 -0500
From: Don Zickus <dzickus@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-ID: <20101122220040.GC18100@redhat.com>
References: <20101122133949.93201b15.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122133949.93201b15.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:39:49PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> arch/sparc/kernel/nmi.c:54: error: redefinition of 'touch_nmi_watchdog'
> include/linux/nmi.h:21: note: previous definition of 'touch_nmi_watchdog' was here
> 
> Caused (or, at least exposed) by commit
> 5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a ("x86, nmi_watchdog: Remove the
> old nmi_watchdog").  Sparc appears to have a touch_nmi_watchdog() and
> defines ARCH_HAS_NMI_WATCHDOG but not CONFIG_HARDLOCKUP_DETECTOR.

Sorry about that.  I'll push another patch to Ingo to fix this.

Cheers,
Don
