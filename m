Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab1JCPoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:44:00 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54930 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335Ab1JCPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:43:56 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Matt Fleming <matt@console-pimps.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
In-Reply-To: <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <m21uuxirxi.fsf@firstfloor.org>
	 <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 16:43:33 +0100
Message-ID: <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 08:28 -0700, Linus Torvalds wrote:
> On Sat, Oct 1, 2011 at 2:35 AM, Matt Fleming <matt@console-pimps.org> wrote:
> >
> > You and me both. Unfortunately, the ia64 guys had a different opinion,
> > http://www.spinics.net/lists/linux-ia64/msg08363.html
> 
> Well, considering that it apparently slows down the single-threaded
> case by 50% on an architecture that actually *matters*, I think the
> whole discussion is somewhat academic, don't you?
> 
> "Scalability" is pretty much never a valid excuse for "slows down the
> common case".

Where did you get the 50% slow down figure from?

Oh, are you referring to Oleg's email about the slow down under kvm?
Yeah, admittedly that's a pretty clear indicator that something is wrong
with the approach in this patch series.

I thought I'd replied to that email but I guess not.

-- 
Matt Fleming, Intel Open Source Technology Center

