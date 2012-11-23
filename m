Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2KWVZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 16:25:43 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:35368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab2KWVZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 16:25:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] Power management fix for v3.7-rc7
Date: Fri, 23 Nov 2012 22:30:12 +0100
Message-ID: <3473497.IpITgra4vk@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.7-rc7

to receive one power management fix for v3.7-rc7 as commit
a7227a0faa117d0bc532aea546ae5ac5f89e8ed7

  PM / QoS: fix wrong error-checking condition

on top of commit f4a75d2eb7b1e2206094b901be09adb31ba63681

  Linux 3.7-rc6

It fixes a bug that has been there for quite a while, but it's a potential
Oops and the fix is -stable material.

Thanks!


 drivers/base/power/qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---------------

Guennadi Liakhovetski (1):
      PM / QoS: fix wrong error-checking condition


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
