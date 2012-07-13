Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab2GMVuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:50:32 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4045 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab2GMVua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:50:30 -0400
Message-ID: <1342216225.15453.15.camel@x61.thuisdomein>
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
Date: Fri, 13 Jul 2012 23:50:25 +0200
In-Reply-To: <20120713210240.GG1707@redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	 <20120713210240.GG1707@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jul 2012 21:50:26.0176 (UTC) FILETIME=[82F95800:01CD6141]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 17:02 -0400, Dave Jones wrote:
> I wish defconfig was actually something useful like this, instead of..
> what the hell is it exactly ? No-one even seems to agree, other than
> "random selection of options, many of which were removed n years ago"

As for the "many of which were removed n years ago" part: in
https://lkml.org/lkml/2011/11/18/211 I suggested to delete
almost 2000 lines from over 400 defconfig files. That would have deleted
all certainly unused macros from all defconfig files. Nothing happened
after that. My fault, I'm afraid.

But just removing all the certainly unused macros probably wouldn't have
made a noticeable difference to anyone using those defconfig files
anyway.


Paul Bolle

