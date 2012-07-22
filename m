Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2GVU3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 16:29:49 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:44702 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab2GVU3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 16:29:47 -0400
X-Greylist: delayed 1155 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2012 16:29:47 EDT
Message-ID: <500C5E35.8090202@dgreaves.com>
Date: Sun, 22 Jul 2012 21:10:29 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
References: <CAG-2HqVOJ=+YxaVOy2NSXt76zW8edJ0uP7NcObHhESwSwFHcqw@mail.gmail.com>
In-Reply-To: <CAG-2HqVOJ=+YxaVOy2NSXt76zW8edJ0uP7NcObHhESwSwFHcqw@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/12 10:55, Tom Gundersen wrote:
> Linus,
> 
>> The point I'm slowly getting to is that I would actually love to have
>> *distro* Kconfig-files, where the distribution would be able to say
>> "These are the minimums I *require* to work". So we'd have a "Distro"
>> submenu, where you could pick the distro(s) you use, and then pick
>> which release, and we'd have something like
> 
> As someone working on one of the smaller distributions (Arch), I think
> it would be even better if rather than having "distro" entries, we'd
> have "application" entries. I.e., entries for applications that have
> specific kernel requirements/suggestions (udev, systemd, upstart,
> bootchart, pulseaudio, networkmanager, etc). If applications have soft
> requirements, they could have sub-entries explaining the benefit of
> enabling each.

Also coming from a 'very small distro' position; I had this problem a few months
ago... my solution was this:

https://github.com/lbt/mer-kernel-check/blob/master/mer_verify_kernel_config#L127

So I'd appreciate something very much along the lines of what various low-level
services need and why since that way we can share work between distros and
package maintainers and offer this kind of ability to our users too.

David

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
