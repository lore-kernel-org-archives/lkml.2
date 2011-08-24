Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1HXQCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:02:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36238 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1HXQCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <yunobzg674q.fsf@aiko.keithp.com>
References: <CAHFgRy_-=6re9DhGywq4CaQFc8Gv57R1NFa3mUtNbShBA73NtA@mail.gmail.com>
	<yunobzg674q.fsf@aiko.keithp.com>
Date: Wed, 24 Aug 2011 12:02:15 -0400
Message-ID: <CAHFgRy_XzE6m=qmY9UPZYT5YYudLF3-+dLHaQyLFsg2fkxTgMg@mail.gmail.com>
Subject: Re: 3.1.0-rc3 -- WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x92/0xa6()
From: Miles Lane <miles.lane@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 1:15 AM, Keith Packard <keithp@keithp.com> wrote:
> On Tue, 23 Aug 2011 01:04:49 -0400, Miles Lane <miles.lane@gmail.com> wrote:
>
>> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x92/0xa6()
>> Hardware name: UL50VT
>> sysfs: cannot create duplicate filename
>
> Can you try drm-intel-fixes from my linux-2.6 tree? It's got a patch on
> top of -rc3 which should fix this.

I usually use patched trees from the v3.0 tar.bz2.  Is there an easy
way for me to get the diff from your GIT repository branch?  My files
are currently 3.1.0-rc2.  I have limited disk space in my laptop's
Linux partition, so am thinking that a GIT tree might not fit.

         Miles
