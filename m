Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2GSBsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:48:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55142 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2GSBsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
Date: Thu, 19 Jul 2012 09:48:30 +0800
Message-ID: <CAKdDr6W50o7AvmC9e9kPcR+uaxx-xkX7iv6AL6sgYK6CYBiMBw@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
From: Steven Yong <woongiap@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 4:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> In addition to the "minimal distro settings", we might also have a few
> "common platform" settings, so that you could basically do a "hey, I
> have a modern PC laptop, make it pick the obvious stuff that a normal
> person needs, like USB storage, FAT/VFAT support, the core power
> management etc".

I am a normal user who is trying to compile newer kernel, to me,
minimal settings for "common platform" is more important than minimal
settings for "distro", minimal settings for distro is for sure
important though, thanks for bringing this RFC up for the benefits of
normal users.

But instead of selecting distro myself, can the minimal settings be
auto-selected by checking my current distro?

Steven
