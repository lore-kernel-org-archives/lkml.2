Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1DMRgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:36:42 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:54901 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1DMRgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:36:41 -0400
Date: Wed, 13 Apr 2011 19:36:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Frank Arnold <farnold@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up mwait_play_dead
Message-ID: <20110413173634.GA1904@gere.osrc.amd.com>
References: <1302711073-31985-1-git-send-email-farnold@amd64.org>
 <4DA5D4D8.7000902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5D4D8.7000902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 09:52:40AM -0700, H. Peter Anvin wrote:
> On 04/13/2011 09:11 AM, Frank Arnold wrote:
> > From: Frank Arnold <frank.arnold@amd.com>
> > 
> > Commit 93789b32dbf355e70f18b17a82e8661677a7f7fb introduced
> > cpuinfo_x86 *c for brevity. It is used to check for the
> > mwait feature flag. The same can be done with a subsequent
> > check for clflsh and save us a second per-cpu pointer
> > dereference.
> > 
> > Signed-off-by: Frank Arnold <frank.arnold@amd.com>
> > Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  arch/x86/kernel/smpboot.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> 
> This should be using this_cpu_has()... if that's not in the tree yet we
> should add it.

Looks like it is still in tip/x86/mm.

We could either redo the patch properly when this_cpu_has() is merged or
add the change against that branch.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
