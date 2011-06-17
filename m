Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab1FQNvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:51:21 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50522 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1FQNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:51:20 -0400
Date: Fri, 17 Jun 2011 15:50:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Add x86 RAS people
Message-ID: <20110617135056.GE18054@aftab>
References: <1308067734-6156-1-git-send-email-bp@amd64.org>
 <20110617132757.GA9659@localhost.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617132757.GA9659@localhost.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 09:27:58AM -0400, Pavel Machek wrote:
> On Tue 2011-06-14 18:08:54, Borislav Petkov wrote:
> > Announce the new RAS infrastructure maintainers. The file patterns below
> > will change after we start the restructuring.
> > 
> > Signed-off-by: Borislav Petkov <bp@amd64.org>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> >  
> > +X86 RAS INFRASTRUCTURE
> > +M:	Tony Luck <tony.luck@intel.com>
> 
> this would be great place to explain "ras"...

Wikipedia has a basic overview: http://en.wikipedia.org/wiki/Reliability,_Availability_and_Serviceability

Our idea is to make error collection and reporting much more easy to
configure and much easily manageable now that reliability features are
much more important on x86. You want to be able to enforce policies
from userspace like, for example, counting errors per hw device (DRAM
ECC errors per DIMM, for example) and undertake actions when thresholds
are reached, implement a much better unified error injection scheme for
testing system reliability, etc.

Another important issue is saving oops information to persistent storage
so that it can be evaluated after reboot. While this is easy to do on
servers with their nvram, we still have no solution for general purpose
laptops. hpa had a project with oopses represented with a 2d barcode but
I still haven't had a chance to look into that.

So things like that, I'm pretty sure I'm leaving something out but you
should be getting the idea...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
