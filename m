Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab1KQP1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:27:45 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:57676 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1KQP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:27:44 -0500
Date: Thu, 17 Nov 2011 10:27:34 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 3/4] platform: (TS-5500) add LED support
Message-ID: <20111117102734.6780299c@v0nbox>
In-Reply-To: <20111026154151.GA1588@elte.hu>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314402027-11293-4-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20111012153415.GA26529@elte.hu>
	<20111016014203.1dfb2cb8@lenov0n>
	<20111026154151.GA1588@elte.hu>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Oct 2011 17:41:51 +0200,
Ingo Molnar <mingo@elte.hu> wrote:
> * Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> 
> > On Wed, 12 Oct 2011 17:34:15 +0200,
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:
> > > 
> > > > From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > > > 
> > > > 
> > > > Signed-off-by: Vivien Didelot
> > > > <vivien.didelot@savoirfairelinux.com>
> > > 
> > > That's not a valid signoff sequence. Did you intend this to be:
> > > 
> > >   From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> > >  
> > >   Signed-off-by: Jonas Fonseca
> > > <jonas.fonseca@savoirfairelinux.com> Signed-off-by: Vivien
> > > Didelot <vivien.didelot@savoirfairelinux.com>
> > > 
> > > ?
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > 
> > Yes, this should be signed off by Jonas Fonseca as well. This will 
> > be updated in the next patches set.
> 
> Note that the patches are currently stalled, due to the build bug i 
> reported. They won't be able to make it into the v3.2 upstream kernel 
> if the bug is not fixed in time.
> 
> The patches are in the -tip tree:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> 
> in the x86/platform branch (also integrated into the master branch).
> 
> Thanks,
> 
> 	Ingo

Hi,

Sorry for the late reply, I wasn't able to work on this platform for
the last two months. Now I'm back :)

I will look at this build failure today.

Thanks for being patient,

	Vivien
