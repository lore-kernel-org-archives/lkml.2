Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab1JZR6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:58:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51676 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932795Ab1JZR6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:58:13 -0400
Message-ID: <1319651860.23224.3.camel@work-vm>
Subject: Re: [PATCH 6/8] clocksource: m86k: Convert to
 clocksource_register_hz/khz
From: john stultz <johnstul@us.ibm.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        lkml <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>,
        uClinux development list <uclinux-dev@uclinux.org>
Date: Wed, 26 Oct 2011 10:57:40 -0700
In-Reply-To: <4EA79629.3040403@snapgear.com>
References: <4ea6fbe8.43310e0a.592c.5416SMTPIN_ADDED@mx.google.com>
	 <CAMuHMdWVdaq+uuCLxuN0EsmJiQdyr9xWpqg6oAeHg3NP_u2V8g@mail.gmail.com>
	 <1319568370.17505.21.camel@work-vm> <4EA79629.3040403@snapgear.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11102617-5518-0000-0000-0000000FBF83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 15:10 +1000, Greg Ungerer wrote:
> Hi John,
> 
> On 26/10/11 04:46, john stultz wrote:
> > Updated to merge the valid bits of the two m68k patches.
> >
> > This converts the m86k clocksources to use clocksource_register_hz/khz
> >
> > This is untested, so any assistance in testing would be appreciated!
> 
> This looks good. I test compiled across all targets these files affect.
> And run tested on ColdFire/5208 (which uses pit.c).

Thanks for testing! I really appreciate it!

> 
> > CC: Geert Uytterhoeven<geert@linux-m68k.org>
> > CC: Greg Ungerer<gerg@uclinux.org>
> > Signed-off-by: John Stultz<johnstul@us.ibm.com>
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> Do you want me to push these via the m68knommu git tree?

I'd prefer it go through either one of the m68k trees.

thanks
-john

