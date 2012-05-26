Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab2EZHXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:23:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52354 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2EZHXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:23:02 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL 0/8] Second batch of arm-soc branches for 3.5
Date: Sat, 26 May 2012 00:22:30 -0700
Message-Id: <1338016958-7887-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the second and last large set of arm-soc branches for the 3.5
merge window. There will likely be a couple of small pull requests next
week (and thereafter fixes).

Descriptions of each branch are in the corresponding request.

Most of them have some trivial merge conflicts with earlier branches or
other code that has gone in since they were staged. Notes below are for
the slightly trickier cases. Just like with the last batch I've pushed
up resolved/<tagname> branches with proposed resolutions if you want
to compare.

cleanup2 branch:
omap_init_clocksource_32k(): Keep the version from this branch but add
in the register_persistent_clock() addition from bd0493e.

clock branch:
An awkward add/remove conflict in mach-kirkwood/common.c. Code is removed
here that was fixed in one of our earlier branches. The right thing to
do is to still just remove the code.

dt2 branch:
gpio-mxs.c: Keep the (port) side but change false -> 0 on the last arg.

soc2 branch:
gpio-samsung.c: Slightly awkward move/change conflict. Essentially
re-apply the second hunk of f10590c9 in the moved function
(exynos5_gpiolib_init()).

cleanup-initcall branch:
Trivial conflict deltas and a deleted file conflict. The removed file
should remain removed.


Thanks!

-Olof
