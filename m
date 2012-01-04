Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2ADTK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:10:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49078 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2ADTK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:10:56 -0500
Date: Wed, 4 Jan 2012 19:10:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ZenIV (was: Re: Status of arm-soc.git for 3.2)
Message-ID: <20120104191042.GB11810@n2100.arm.linux.org.uk>
References: <201201032243.06440.arnd@arndb.de> <20120104100016.GK2914@n2100.arm.linux.org.uk> <20120104181703.GA11810@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1201041337370.2907@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1201041337370.2907@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 01:55:48PM -0500, Nicolas Pitre wrote:
> On Wed, 4 Jan 2012, Russell King - ARM Linux wrote:
> > I've now disabled all access to my git tree there, and restarted apache.
> > We will see whether that improves stability - I suspect it will do because
> > I reckon that the problem is that the smart git stuff is what's killing
> > the machine.
> 
> I'm sure that is the case.  However faulty hardware could still be the 
> root cause, but without the load from Git the machine might become 
> loaded lightly enough you might not see any ill effects before quite a 
> while.

When it's serving the next Fedora release (it's one of the official
mirrors) I'm sure any problems like that would become noticable - but
they haven't yet.  It purely seems to be something git is doing which
is killing the machine.

Another kernel developer has mentioned to me that he believes that Git
disagrees with Pentium 4 CPUs, suggesting that Git does something which
the P4 microcode really doesn't like: he's found that Git is dog slow
on his P4 machines as well.

That ties up with my experience too.

So, I suggest rather than blaming this problem on the machines, maybe
there could be something behind this: maybe Git is just plain incompatible
with Pentium 4 CPUs.

> If so I'd suggest you consider one of the hosting alternatives readily 
> available to you for publishing your Git tree.  I'm sure any hurdle can 
> be leveled out very quickly for the core ARM Linux repository.  I can 
> certainly facilitate things if you wish.

I'm already aware of your attempts in the background.
