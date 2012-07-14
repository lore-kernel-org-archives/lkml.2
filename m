Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2GNJv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 05:51:28 -0400
Received: from dspnet.fr ([188.165.44.67]:56616 "EHLO dspnet.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab2GNJv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 05:51:26 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2012 05:51:26 EDT
Date: Sat, 14 Jul 2012 11:44:34 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120714094434.GB19640@dspnet.fr>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <alpine.LNX.2.00.1207140014070.10676@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207140014070.10676@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 12:33:51AM +0200, Jesper Juhl wrote:
> How about we start cutting down on the options and start saying "a Linux 
> system will provide feature x and y - always ...".
> Stuff like (and I'm just pulling random stuff out here) - ASLR, seccomp, 
> 250HZ minimum etc etc.. We could cut the KConfig options down to 10% of 
> what they are now if we just made a few (hard) choices about some things 
> that would always be there that everyone could count on.  If people want 
> to deviate from the default minimum, sure, let them, but put it under 
> *custom*, *embedded*, *specialized distro*, *you know what you are doing* 
> menu options.

In number of options the "infrastructure" options are at most 20% of
the total.  The other 80% are individual drivers, hardware (like
network cards, serial devices, usb devices, video...) or software
(crypto algorithms, partition formats, codepages, filesystems...).
You're going to have a hard time slashing 90% of that.

  OG.

