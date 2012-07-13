Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab2GMVVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:21:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48084 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2GMVVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:21:11 -0400
MIME-Version: 1.0
In-Reply-To: <50009051.3060806@schaufler-ca.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <50009051.3060806@schaufler-ca.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 14:20:50 -0700
X-Google-Sender-Auth: QtGmh-sjclcoePpE5ULJ63pG4uQ
Message-ID: <CA+55aFyD_=aMoYKBocWFXXZ7RypWhZemOLyqC4p7oqfDRinqDQ@mail.gmail.com>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 2:17 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Oh dear. I would expect Fedora to say that they require SELinux,
> thereby making it unusable by anyone doing LSM development.

Oh, *absolutely*.

These options would *not* be meant for people doing odd things and
experienting with configs.

If you do that, then you might *start* by saying "I want this distro"
to get the initial guesstimate of the config file you want, but then
edit the .config by hand later (and remove the "I want all the Fedora
requirements" option, of course).

This is explicitly and exclusively for normal users. The whole point
of "expert configurator for special cases" should not be given any
thought at all - those kinds of people should simply answer "No" to
the "Do you want the distro basic kconfig requirements" question.

                Linus
