Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467Ab2CSLqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:46:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42908 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2CSLqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:46:23 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 19 Mar 2012 08:46:01 -0300
Message-ID: <CAMOw1v6N4xpwnB7yRCUtw=AdyjYk9DYwh07HdtOaWU0smRX1Cw@mail.gmail.com>
Subject: [ANNOUNCE] kmod 7
To: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmod 7 is out:

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-7.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-7.tar.sign

Just a bug-fix release with some bugs found mainly by Debian guys.
Check the NEWS file for more information.

Thanks a lot for all of you helping with debugging, testing and patches.

Shortlog is below.

Lucas De Marchi

--

Dave Reisner (1):
      modprobe: fix error path in removing modules

Lucas De Marchi (7):
      modprobe: don't check if module builtin to decide if it's builtin
      modprobe: always try to remove all modules in command line
      modprobe: set log prio to 0 if user passed -q arg
      config: use order /etc, /run, /lib
      build-sys: re-organize configure.ac
      build-sys: don't set CFLAGS and LDFLAGS
      kmod 7

Randy Witt (2):
      Add CC_CHECK_LDFLAGS_APPEND m4 macro.
      configure.ac: Move link only flags out of CFLAGS and into LDFLAGS.
