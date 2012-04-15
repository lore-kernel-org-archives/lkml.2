Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2DOUVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 16:21:14 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64122 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378Ab2DOUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 16:21:12 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204131033240.2542@ionos>
References: <alpine.LFD.2.02.1204131033240.2542@ionos>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sun, 15 Apr 2012 16:20:39 -0400
X-Google-Sender-Auth: fn0pAcDEgxnCQ67i3fY8qxXbbwQ
Message-ID: <CAP=VYLqQf0ZmYPATyE2q=9QtK+eDb8SeRbkusdCjg93fzy2cqA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.4-rc2-rt4
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 8:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.4-rc2-rt4 release.

[...]

I've made four largely trivial changes to the broken out queue
so that the commits can all be reliably fed to "git am" on
a patch-by-patch basis without warnings or errors.

Not sure what is the most convenient for you to get "patches of
patches" from people, but the ones I've made are here:

http://git.kernel.org/?p=linux/kernel/git/paulg/3.4-rt-patches.git;a=shortlog;h=refs/heads/3.4-rc2-rt4-git-am-fixes

I've created a git repo of your rt patches, akin to what is done for stable,
and put the cleanups on a branch.  I'll keep master reserved for tracking
your actual releases, and will tag accordingly.

If you can think of something that better matches your workflow, let
me know and I'll adapt accordingly.

Thanks,
Paul.
----

The following changes since commit f99f81e7ddc08d220dd03a51cae06f59cfa021b7:

  patches-3.4-rc2-rt4.tar.xz (2012-04-15 15:14:55 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/3.4-rt-patches.git
3.4-rc2-rt4-git-am-fixes

for you to fetch changes up to 2d3671bebaea24768cf443822959122efaeb8208:

  git-am: whitespace fixes. (2012-04-15 15:28:57 -0400)

----------------------------------------------------------------
Paul Gortmaker (4):
      delete dup mail header from
sched-teach-migrate_disable-about-atomic-contexts.patch
      fix subjectless patches
      git-am: ensure Subject: follows From:
      git-am: whitespace fixes.
