Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994Ab2KBXvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:51:00 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53336 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761886Ab2KBXu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:50:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: [GIT PULL] Power management update for v3.7-rc4
Date: Sat, 03 Nov 2012 00:55:05 +0100
Message-ID: <2019209.N9gW4uov1x@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.7-rc4

to receive one power management update for v3.7-rc4 as commit
29c4bcddaa62e2b9fd2ba85668f6718b0b43f0e3

  cpufreq / powernow-k8: Change maintainer's email address

on top of commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64

  Linux 3.7-rc3

It changes the email address of Andreas Herrmann in the
drivers/cpufreq/powernow-k8.c file that he is the maintainer of.

Thanks!


 drivers/cpufreq/powernow-k8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---------------

Andreas Herrmann (1):
      cpufreq / powernow-k8: Change maintainer's email address


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
