Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1JSPEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:04:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab1JSPEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:04:34 -0400
Date: Wed, 19 Oct 2011 17:04:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
In-Reply-To: <20111019150122.GA6157@schottelius.org>
Message-ID: <alpine.LNX.2.00.1110191702470.3541@pobox.suse.cz>
References: <20111017175906.GA3461@schottelius.org> <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz> <20111017214050.GA1408@schottelius.org> <20111019150122.GA6157@schottelius.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Nico Schottelius wrote:

> > [...] 
> > I've attached the xev output of fn+{F1-F12}.
> > 
> > F1-F4 are correct, though
> >   F3 = Expose on MacOS X (**)
> >   F4 = Dashboard (**)
> > F5: not mapped at all: Is KeyboardLightDecrease on MacOSX (*)
> > F6 is XF86AudioPrev incorrect: Should be  KeyboardLightIncrease (*)
> > F7 is XF86AudioPlay incorrect: Should be XF86AudioPrev
> > F8 is XF86AudioNext incorrect: Should be XF86AudioPlay
> > F9 is XF86AudioMute incorrect: Should be XF86AudioNext
> > F10 is XF86AudioLowerVolume incorrect: Should be XF86AudioMute
> > F11 is XF86AudioRaiseVolume incorrect: Should be XF86AudioLowerVolume 
> > F12 is XF86Eject incorrect: Should be  XF86AudioRaiseVolume 
> > 
> > Thus F7-12 are shifted by one to left in reality and as the MacBook Air
> 
> if I want to correct these bugs, which tree should I use as the base?
> And when I corrected those, to whom to submit?

Hi,

please use hid tree, for-next branch. The tree is located on kernel.org.

> I guess the general approach would be to branch out, if it's a mba4,2,
> then apply the following mapping, correct?

Yes, there are mapping tables in hid-apple.c already, so just introduce a 
new one.

I am a bit surprised that they are needed though, the original report 
stated that the the table is identical to the one that is already there 
(apple_fn_keys[]).

-- 
Jiri Kosina
SUSE Labs
