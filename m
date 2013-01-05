Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3AEN7i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 08:59:38 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63087 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3AEN7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 08:59:34 -0500
Date: Sat, 5 Jan 2013 14:59:25 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Kees Bakker <kees.bakker@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: drm/nouveau E[     DRM] fail ttm_validate
Message-ID: <20130105135925.GA3131@joi.lan>
References: <65b9.50e6c93a.b1791@altium.nl>
 <65b9.50e6c93a.b1791@altium.nl>
 <20130104174958.GA15275@joi.lan>
 <50E748C7.10202@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E748C7.10202@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 10:25:27PM +0100, Kees Bakker wrote:
> On 04-01-13 18:49, Marcin Slusarz wrote:
> > On Fri, Jan 04, 2013 at 01:21:14PM +0100, Kees Bakker wrote:
> >> Hi,
> >>
> >> Right after I upgraded to Ubuntu quantal I started seeing these
> >> messages:
> >> Jan  4 12:18:12 koli kernel: [ 3705.970720] nouveau E[     DRM] fail ttm_validate
> >> Jan  4 12:18:12 koli kernel: [ 3705.970726] nouveau E[     DRM] validate vram_list
> >> Jan  4 12:18:12 koli kernel: [ 3705.970760] nouveau E[     DRM] validate: -12
> > This is userspace bug. See below.
> >
> >> A few times I had corrupted graphics, and I had to stop X. Restarting didn't
> >> help and I had to reboot.
> >>
> >> I'm running my own 3.7.1 kernel, so I also installed the 3.7.0 development kernel
> >> from Ubuntu (3.7.0-7). And that kernel shows these messages too.
> >>
> >> With the Ubuntu kernel the graphics corruption is milder. I can continue to work. Sometimes
> >> I get a burst of the messages, but I have no clue how it is triggered.
> >>
> >> Now the strange thing is that I was running my 3.7.1 kernel on Ubuntu precise
> >> and I have never seen these messages before. What could be the case is that
> >> xorg is doing something new and that is causing the errors.
> >>
> >> xserver-xorg-video-nouveau
> >>     precise 1:1.0.2-0ubuntu3
> >>     quantal 1:0.0.16+git20111201+b5534a1-1build2
> > (Please do not use distro codenames when reporting bugs upstream)
> >
> > Quantal, being newer release than Precise, ships much older Nouveau DDX, WTF?
> > You used some PPA with Precise?
> Sorry about that. That was a typo. I meant to say:
>     quantal 1:1.0.2-0ubuntu3
>     precise 1:0.0.16+git20111201+b5534a1-1build2
> 
> >
> > 0.0.16 is known to behave like that - you need to upgrade to >= 1.0.
> 
> In other words, I have >= 1.0. But you suggest that it shouldn't
> happen with >= 1.0
> Should I report it on the nouveau list at freedesktop.org ?

Ugh, it was unexpected :/

Please follow instructions from http://nouveau.freedesktop.org/wiki/Bugs and
open new bug report. I have some patches which may help in narrowing it down,
but I would like to see all bug report data first.

Marcin

