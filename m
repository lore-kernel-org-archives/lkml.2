Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031551Ab2CWAua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:50:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:45710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413Ab2CWAu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:50:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="80647252"
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 22 Mar 2012 17:51:39 -0700
In-Reply-To: <CA+55aFygUGmL0iCKYn5DBitrPSm0GHZ8e5j0j2OzcBcAkUMiFw@mail.gmail.com>
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>
	 <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
	 <4F6BC1C4.6050502@zytor.com>
	 <CA+55aFygUGmL0iCKYn5DBitrPSm0GHZ8e5j0j2OzcBcAkUMiFw@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332463899.16101.158.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 17:37 -0700, Linus Torvalds wrote:
> On Thu, Mar 22, 2012 at 5:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > Looks great to me.  Linus, do you want this one later in the window if
> > it tests out OK between now and then, or is it too late?
> 
> It's small and trivial, so it's fine. I *would* like to hear whether
> it actually makes any real difference, though. I do see "intel_idle()"
> as a big cost in idle profiles, and I assume that translates to power
> use too, but if you guys have some actual numbers, that would be even
> better.

I was reviewing this code in some other context and thought this
optimization makes sense. Unless someone beats me, I can collect some
data on Monday.

thanks,
suresh

