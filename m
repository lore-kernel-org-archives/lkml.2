Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2BWSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:16:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45992 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756595Ab2BWSQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:16:57 -0500
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18CBzUt7aMCPzVjHH8ggyEUDFcPz5Fm8HgRv/nvc3
	oN76QkGCEokzsZ
From: Sven Joachim <svenjoac@gmx.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: i915 regression with 3.3-rc3+git
References: <4F3EBD0D.7000906@gmail.com>
	<20120223084106.4b132532@jbarnes-desktop>
Date: Thu, 23 Feb 2012 19:16:54 +0100
In-Reply-To: <20120223084106.4b132532@jbarnes-desktop> (Jesse Barnes's message
	of "Thu, 23 Feb 2012 08:41:06 -0800")
Message-ID: <8739a12z55.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-23 17:41 +0100, Jesse Barnes wrote:

> On Fri, 17 Feb 2012 21:48:13 +0100
> Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
>
>> Hello,
>> 
>> i've upgraded from 3.2.0-rc7 to post 3.3.0-rc3 git 
>> 4903062b5485f0e2c286a23b44c9b59d9b017d53, attached you can find dmesg 
>> with drm.debug=0xfff
>> 
>> This started to appear in logs:
>> 
>> [drm:intel_framebuffer_init] *ERROR* unsupported pixel format
>> 
>> X is getting a wrong resolution (log attached) and there's a lot of 
>> flickering, if i try to play a video the desktop turns black, the other 
>> ttys still works fine though.

I noticed very similar problems when I upgraded from 3.2 to 3.3-rc4 on
my laptop.  Same error message but the symptoms were worse, got a black
screen when the display manager started X.

> Can you check the drm-intel-fixes branch at
> git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/drm-intel.git?
> It has a fix for laod detection that might help.

Works great for me, thanks.

Cheers,
       Sven
