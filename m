Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1GaPcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 11:32:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63060 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1GaPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 11:32:29 -0400
Date: Sun, 31 Jul 2011 19:32:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
Message-ID: <20110731153225.GJ2209@sun>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
 <20110731110641.GG2209@sun>
 <CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 05:20:15PM +0200, Francis Moreau wrote:
> Hi Cyrill
> 
> On Sun, Jul 31, 2011 at 1:06 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
> >> Hello,
> >>
> >> I'm seeing those kernel message when resuming:
> >>
> >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> >> [  524.973288] Do you have a strange power saving mode enabled?
> >> [  524.973289] Dazed and confused, but trying to continue
> >>
> >> I don't know if it's important or not because the system seems to work
> >> after but maybe it worths to report
> >>
> >
> > Hi Francis, cpu please?
> >
> 
> Still the same which causes some kvm-tools madness ;)
> 

OK, thanks Francis, I've CC'ed a couple of people involved into
x86 perf implementation. I believe at moment of wakeup we could
drop any/all overflow flags in perf registers (still didn't look
into, will try to find some time a bit later).

	Cyrill
