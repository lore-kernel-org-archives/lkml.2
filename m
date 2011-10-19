Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab1JSPB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:01:28 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:55085 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab1JSPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:01:27 -0400
Date: Wed, 19 Oct 2011 17:01:22 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Keyboard and mouse issues on MacBook Air (4,2)
Message-ID: <20111019150122.GA6157@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <20111017175906.GA3461@schottelius.org>
 <alpine.LRH.2.00.1110172015050.3869@twin.jikos.cz>
 <20111017214050.GA1408@schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017214050.GA1408@schottelius.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.1.0-rc6-gbee709a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jiri,

regarding the misplaced keys:

Nico Schottelius [Mon, Oct 17, 2011 at 11:40:50PM +0200]:
> [...] 
> I've attached the xev output of fn+{F1-F12}.
> 
> F1-F4 are correct, though
>   F3 = Expose on MacOS X (**)
>   F4 = Dashboard (**)
> F5: not mapped at all: Is KeyboardLightDecrease on MacOSX (*)
> F6 is XF86AudioPrev incorrect: Should be  KeyboardLightIncrease (*)
> F7 is XF86AudioPlay incorrect: Should be XF86AudioPrev
> F8 is XF86AudioNext incorrect: Should be XF86AudioPlay
> F9 is XF86AudioMute incorrect: Should be XF86AudioNext
> F10 is XF86AudioLowerVolume incorrect: Should be XF86AudioMute
> F11 is XF86AudioRaiseVolume incorrect: Should be XF86AudioLowerVolume 
> F12 is XF86Eject incorrect: Should be  XF86AudioRaiseVolume 
> 
> Thus F7-12 are shifted by one to left in reality and as the MacBook Air

if I want to correct these bugs, which tree should I use as the base?
And when I corrected those, to whom to submit?

I guess the general approach would be to branch out, if it's a mba4,2,
then apply the following mapping, correct?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
