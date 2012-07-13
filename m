Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2GMV4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab2GMV4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:56:04 -0400
Date: Fri, 13 Jul 2012 17:55:46 -0400
From: Dave Jones <davej@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120713215546.GH1707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Paul Bolle <pebolle@tiscali.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <greg@kroah.com>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	Debian Kernel Team <debian-kernel@lists.debian.org>,
	OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <1342216225.15453.15.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342216225.15453.15.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:50:25PM +0200, Paul Bolle wrote:

 > But just removing all the certainly unused macros probably wouldn't have
 > made a noticeable difference to anyone using those defconfig files
 > anyway.

My point is that I don't think there's many people actually using them.
(maybe more on the niche platforms, but x86[64] ? I'm sceptical they're used at all)

	Dave
 
