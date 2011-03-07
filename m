Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab1CGVhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:37:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33017 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab1CGVhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:37:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [ANNOUNCE] suspend-utils 1.0 has been released
Date: Mon, 7 Mar 2011 22:37:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, suspend-devel@lists.sourceforge.net,
        Pavel Machek <pavel@ucw.cz>,
        Stefan Seyfried <stefan.seyfried@googlemail.com>,
        Rodolfo Garcia <kix@kix.es>, Luca Tettamanti <kronos.it@gmail.com>,
        "Alon Bar-Lev" <alon.barlev@gmail.com>, Holger Macht <hmacht@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103072237.32194.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday I released version 1.0 of the suspend-utils package including
s2disk/resume, s2ram, s2both and several supporting programs.  It contains
the final official s2ram whitelist and should work with all of the Linux
kernels supporting the user space hibernation interface released to date.

The suspend-utils-1.0 package is available for download from:
http://sourceforge.net/projects/suspend/files/suspend/suspend-1.0/suspend-utils-1.0.tar.bz2/download

For details about the release please refer to the ReleaseNotes file within
the package.  For the full list of changes, please refer to the ChangeLog
file.

The development of s2ram is not going to be continued after this release
and I'm not going to add any new entries to the whitelist.  Consequently,
please do not report new machines that work with s2ram and are not listed.
Still, bugs reported against s2ram will be handled and possibly fixed, so
please report if you find one.  The hibernation-related utilities are still
going to be worked on in the future.

Using the opportunity I'd like to thank all of the people who contributed
to the suspend-utils project and made this release possible, especially
Pavel Machek who inspired the development of s2disk/resume and created the
first version of s2ram, Stefan Seyfried who helped to integrate the
utilities with SUSE and openSUSE power management facilities and added a ton
of machines to the s2ram whitelist, Luca Tettamanti who's been working on
the project's web page, among other things, Alon Bar-Lev who added the
configuration and build scripts, and our last s2ram whitelist maintainer
Rodolfo Garcia.  Your work helped many Linux users to benefit from working
suspend-to-RAM, so thanks a lot!

There's one important administrative change related to the release.  Namely,
the suspend-devel mailing list, that recently has been mostly used for
reporting new machines to be added to the s2ram whitelist, is going to be
closed.  Please send bug reports and other messages related to the
suspend-utils package to linux-pm@lists.linux-foundation.org instead.

Thanks and enjoy,
Rafael
