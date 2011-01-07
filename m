Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1AGOuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:50:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:58385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab1AGOuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:50:17 -0500
Subject: Re: [PATCH 3/6] x86, NMI: Add priorities to handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Robert Richter <robert.richter@amd.com>,
        ying.huang@intel.com, gorcunov@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110107144318.GU2317@redhat.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
	 <1294348732-15030-4-git-send-email-dzickus@redhat.com>
	 <1294405791.2016.450.camel@laptop>  <20110107144318.GU2317@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 07 Jan 2011 15:50:17 +0100
Message-ID: <1294411817.2016.454.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 09:43 -0500, Don Zickus wrote:

> > I had to add the below to make things build here.
> > 
> > ---
> > Index: linux-2.6/arch/x86/kernel/kgdb.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/kgdb.c
> > +++ linux-2.6/arch/x86/kernel/kgdb.c
> > @@ -48,6 +48,7 @@
> >  #include <asm/apicdef.h>
> >  #include <asm/system.h>
> >  #include <asm/apic.h>
> > +#include <asm/nmi.h>
> >  
> >  struct dbg_reg_def_t dbg_reg_def[DBG_MAX_REG_NUM] =
> >  {
> > 
> 
> Doh.  I missed a spot.  Thanks for the catch.  I'll add that and repost.

I already fixed it up and send it Ingo-wards.
