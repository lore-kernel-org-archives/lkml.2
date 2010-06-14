Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0FNHic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:38:32 -0400
Received: from mx.ij.cx ([212.13.201.15]:50269 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341Ab0FNHia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:38:30 -0400
Date: Mon, 14 Jun 2010 08:38:27 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Michal Marek <mmarek@suse.cz>
Subject: Re: Appending '+' to version, since 2.6.35-rc2
In-Reply-To: <20100614065221.GB3999@x200>
Message-ID: <alpine.NEB.2.01.1006140822080.28879@jrf.vwaro.pbz>
References: <alpine.NEB.2.01.1006131729430.2991@jrf.vwaro.pbz> <20100614065221.GB3999@x200>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Alexey Dobriyan wrote:

> On Sun, Jun 13, 2010 at 08:01:26PM +0100, Mark Hills wrote:
> > Commit 85a256d adds a new feature:
> > 
> >   [...] When CONFIG_LOCALVERSION_AUTO is not enabled, a `+' is appended
> >   to the kernel version to represent that the kernel has been revised
> >   since the last release unless "make LOCALVERSION=" was used to uniquely
> >   identify the build.
> > 
> > I'm finding this inconvenient for 'casual' kernel development.
> > 
> > For example, my usual workflow goes something like:
> > 
> > 1) find something I suspect is a bug
> > 2) upgrade to the latest stable or -rc kernel, to confirm
> > 3) experiment with patch to fix it
> > 
> > Since 2.6.35-rc2, going from step 2 to 3 causes the version of the kernel 
> > to change: forcing time-consuming rebuilds,
> 
> init/version.c
> kernel/configs.c
> + whatever patch has changed
> + vmlinux 2 or 3 times
> 
> That's not time consuming.

There is also the modpost step, which is most time consuming.

> 
> > installing modules, and manual 
> > changes associated with a new version number; eg. updating the lilo/grub 
> > config, or the distribution's initrd.
> 

-- 
Mark
