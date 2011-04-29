Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab1D2UYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:24:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33811 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1D2UYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:24:06 -0400
Date: Fri, 29 Apr 2011 22:23:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Boris Ostrovsky <ostr@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jvpeetz@web.de" <jvpeetz@web.de>
Subject: Re: [PATCH] Subject: [PATCH] x86, AMD: K8 Rev.A-E processors are
 subject to erratum 400
Message-ID: <20110429202338.GA21523@aftab>
References: <1304106663-3720-1-git-send-email-ostr@amd64.org>
 <20110429195548.GA17166@elte.hu>
 <4DBB1B6E.9060203@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBB1B6E.9060203@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 04:11:26PM -0400, Boris Ostrovsky wrote:
> On 04/29/2011 03:55 PM, Ingo Molnar wrote:
> >
> > * Boris Ostrovsky<ostr@amd64.org>  wrote:
> >
> >> Signed-off-by: Boris Ostrovsky<Boris.Ostrovsky@amd.com>
> >> Acked-by: Borislav Petkov<borislav.petkov@amd.com>
> >> Reported-by: Joerg-Volker Peetz<jvpeetz@web.de>
> >> Tested-by: Joerg-Volker Peetz<jvpeetz@web.de>
> >>
> >> Older AMD K8 processors (Revisions A-E) are affected by erratum 400 (APIC
> >> timer interrupts don't occur in C states greater than C1). This, for example,
> >> means that X86_FEATURE_ARAT flag should not be set for these parts.
> >>
> >> This addresses regression introduced by commit
> >> b87cf80af3ba4b4c008b4face3c68d604e1715c6 (x86, AMD: Set ARAT feature on AMD
> >> processors") so it is somewhat high priority.
> >
> > Hm, what is the regression, how do users see it? Hangs? Delays? Crashes?
> > Something more benign? The changelog should really contain such information.
> 
> 
> The system becomes unresponsive until an external interrupt (e.g. 
> keyboard input) happens. The most obvious effect is that time is not 
> reported correctly. We haven't seen anything worse but that's probably 
> bad enough.
> 
> Do you want me to resubmit the patch with updated comments?

Yes please. Being too verbose is much better than being laconic with the
commit message.

Also, please put those lines

Signed-off-by: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Acked-by: Borislav Petkov <borislav.petkov@amd.com>
Reported-by: Joerg-Volker Peetz <jvpeetz@web.de>
Tested-by: Joerg-Volker Peetz <jvpeetz@web.de>

_after_ the commit message.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
