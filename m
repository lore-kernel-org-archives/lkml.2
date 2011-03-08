Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1CHTDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 14:03:24 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34662 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab1CHTDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 14:03:21 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [AppArmor 0/3] Cleanups to AppArmor's build
Date: Tue,  8 Mar 2011 11:03:06 -0800
Message-Id: <1299610989-3917-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches have all been out to the lkml/lsm and have sat in
the AppArmor tree for a while.

The following changes since commit eae61f3c829439f8f9121b5cd48a14be04df451f:

  TOMOYO: Fix memory leak upon file open. (2011-03-03 10:13:26 +1100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jj/apparmor-dev.git security-next

John Johansen (3):
      AppArmor: Cleanup make file to remove cruft and make it easier to read
      AppArmor: cleanup generated files correctly
      AppArmor: kill unused macros in lsm.c

 security/apparmor/Makefile |   38 +++++++++++++++++++++++++++++++++-----
 security/apparmor/lsm.c    |    2 --
 2 files changed, 33 insertions(+), 7 deletions(-)

