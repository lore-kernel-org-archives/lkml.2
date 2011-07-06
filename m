Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1GFB2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 21:28:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58008 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1GFB2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 21:28:12 -0400
Date: Tue, 5 Jul 2011 18:27:39 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: give names to realmode wakeup flags
Message-ID: <20110706012739.GA32221@outflux.net>
References: <1309818953-769-1-git-send-email-kees.cook@canonical.com>
 <1309818953-769-2-git-send-email-kees.cook@canonical.com>
 <4E1392BA.8010708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1392BA.8010708@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 03:39:54PM -0700, H. Peter Anvin wrote:
> On 07/04/2011 03:35 PM, Kees Cook wrote:
> > Instead of using literals, use a common set of names for the
> > user-controlled realmode wakeup flags.
> > 
> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> 
> I'm sorry, but I really have to complain about this:
> 
> This was a very unfriendly thing to do.

Obviously I wasn't trying to be unfriendly. :P

> You took a patch that is a bug fix to be considered for -stable,
> and you applied it *on top of a cleanup patch*.

It wasn't clear to me if the MISC_ENABLE reload should be considered for
stable (it does technically "more" than my original patch, and changes
the resume header structure, etc). If it should be forwarded to -stable,
that's fine too. I just didn't want to presume.

> They should not have been part of the same patchset,
> but *certainly* not in that order.

Since they hit the same .h file in the same location, I wasn't sure what
order to do it in. It seemed unhelpful to send them separately.

> Please resubmit.

Sure thing -- in the opposite order, or totally separate from each other?

-Kees

-- 
Kees Cook
Ubuntu Security Team
