Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2GMVDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab2GMVC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:02:59 -0400
Date: Fri, 13 Jul 2012 17:02:40 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120713210240.GG1707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	Debian Kernel Team <debian-kernel@lists.debian.org>,
	OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 01:37:41PM -0700, Linus Torvalds wrote:

 > The point I'm slowly getting to is that I would actually love to have
 > *distro* Kconfig-files, where the distribution would be able to say
 > "These are the minimums I *require* to work".

As long as you don't mind these being added after the fact, I suppose
it would be workable.  The reason I say that is sometimes, it even catches *us*
by surprise.  We recently found out our virtualisation guys started
using sch_htb for example, and we inadvertantly broke it when we moved
its module to a 'not always installed' kernel subpackage. (and before that, 9PFS..)

People don't tell us anything, but somehow expect things to keep working.

 > In addition to the "minimal distro settings", we might also have a few
 > "common platform" settings, so that you could basically do a "hey, I
 > have a modern PC laptop, make it pick the obvious stuff that a normal
 > person needs, like USB storage, FAT/VFAT support, the core power
 > management etc".

I wish defconfig was actually something useful like this, instead of..
what the hell is it exactly ? No-one even seems to agree, other than
"random selection of options, many of which were removed n years ago"

	Dave

