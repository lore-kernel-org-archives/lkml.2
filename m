Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2GMWUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:20:39 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:3892 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab2GMWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:20:36 -0400
Message-ID: <1342218034.15453.28.camel@x61.thuisdomein>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Paul Bolle <pebolle@tiscali.nl>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Date: Sat, 14 Jul 2012 00:20:34 +0200
In-Reply-To: <20120713215546.GH1707@redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
	 <1342216225.15453.15.camel@x61.thuisdomein>
	 <20120713215546.GH1707@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jul 2012 22:20:34.0894 (UTC) FILETIME=[B90DCEE0:01CD6145]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 17:55 -0400, Dave Jones wrote:
> My point is that I don't think there's many people actually using them.
> (maybe more on the niche platforms, but x86[64] ? I'm sceptical they're used at all)

I guess you're right. Personally, I tend to start my journeys in self
compiled kernel land by using something I know that works as a starting
point. Ie, I use some distribution's kernel, notice that things seem to
mostly work, and use the .config of that kernel to start exploring
whatever it is I'm interested in. I can't remember ever feeling the urge
to use some defconfig to start these journeys. 


Paul Bolle

