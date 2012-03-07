Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2CGMLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:11:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34923 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab2CGMLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:11:40 -0500
Date: Wed, 7 Mar 2012 13:11:38 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc6
Message-ID: <20120307121138.GB5237@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxHj-7fQ0+yJv4WaeKCGha5+a+J=gtHi6m6EWg58q7Ljw@mail.gmail.com>
 <20120307103227.GA5237@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120307103227.GA5237@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 11:32:27AM +0100, Borislav Petkov wrote:
> On Sat, Mar 03, 2012 at 06:57:31PM -0800, Linus Torvalds wrote:
> > Hmm. Nothing much to say about this -rc: it really is all small fixes
> > and cleanups.
> > 
> > In fact, it's been calm enough that this *might* be the last -rc, but
> > we'll see how the upcoming week goes. If it stays calm (and hopefully
> > even calms down some more), there doesn't seem to be any major reason
> > to drag out the release cycle any more.
> > 
> > But hey, that does imply that people who have seen regressions should
> > re-check them and holler loudly if they are still seeing problems.
> 
> Just a couple of warnings, just saw them when booted
> 3.3.0-rc6-00104-gf3969bf78f14 yesterday on this box. I'm ccing Paul for
> the first two,

Ok, looks like Paul knows about those already:
http://marc.info/?l=linux-kernel&m=132744022215850 and further.

@Paul: which patch is the latest adding rcu_idle_enter/_exit() calls to pm_idle
assignees, which you'd like me to test?

Thanks.

-- 
Regards/Gruss,
Boris.
