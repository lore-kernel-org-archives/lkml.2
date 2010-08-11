Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab0HKSHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:07:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50772 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab0HKSHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:07:02 -0400
Subject: Re: linux-next: Tree for August 11 (hpet)
From: john stultz <johnstul@us.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100811085138.67782931.randy.dunlap@oracle.com>
References: <20100811140009.6ff33109.sfr@canb.auug.org.au>
	 <20100811085138.67782931.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 11:06:25 -0700
Message-ID: <1281549985.1745.65.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 08:51 -0700, Randy Dunlap wrote:
> On Wed, 11 Aug 2010 14:00:09 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > As the merge window is open, please do not add 2.6.37 material to your
> > linux-next included trees until after 2.6.36-rc1.
> > 
> > Changes since 20100810:
> 
> 
> on i386 (X86_32):
> 
> arch/x86/kernel/hpet.c:840: warning: integer overflow in expression
> 
> 	hpet_freq = FSEC_PER_NSEC * NSEC_PER_SEC;

I think the patch from Chris Wilson resolves this. 

Thomas: I sent this with another fix that needs to go in. Could you
merge those in when you get a chance?

thanks
-john


