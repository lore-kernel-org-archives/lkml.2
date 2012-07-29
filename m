Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2G2XYx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 19:24:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53870 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2G2XYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 19:24:51 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:cab:32f2:2e5d:2fb]
Date: Sun, 29 Jul 2012 16:24:51 -0700
Message-ID: <CAOesGMhKeCDG8uUohyq9yJM9+-OdhNtLfZKZ1K4ThiUiHJMepw@mail.gmail.com>
Subject: [GIT PULL 0/2] ARM: (small) second batch of updates
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Here are two pull requests for branches that arrived to us pretty
close to when the merge window opened, so we wanted to let them sit in
-next for a bit before sending them in.

Most of it is Renesas shmobile updates, but also a few Exynos and PXA patches.

In addition to this, we have three more branches that we will likely
send up later this week; some device tree updates for Marvell/Orion,
some cpuidle updates for OMAP and a PCI cleanup series that has a
couple of small issues left to debug.


Thanks,

-Olof
