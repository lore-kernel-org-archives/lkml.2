Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab2C1HOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:14:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52214 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2C1HOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:14:38 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 0/5] Second batch of arm-soc changes
Date: Wed, 28 Mar 2012 00:13:57 -0700
Message-Id: <1332918842-13521-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the second batch of arm-soc changes for this merge window. As Arnd
mentioned with the first cover letter, most of these either had external
dependencies that have now been pulled in, or just needed a bit more
linux-next bake time due to getting picked up close to the 3.3 release.


There are 128 non-merge patches, with a total diffstat of:

 346 files changed, 10790 insertions(+), 2792 deletions(-)

So, while there's been some good cleanups especially in the first branch,
there's been a net addition of code:

* New SoC family support for Samsung EXYNOS5250: clock tables, driver
  updates, etc means net gain in code.
* Added device tree conversions. Once we start to sunset non-device tree
  boards on the enabled platforms, we should see payback in code removal.
* Common clock framework. As SoCs get converted over to the framework,
  we should see more code removal from this as well.


There are a handful of merge conflicts on the branches, nothing that
should be too messy to sort out. I've described each conflict in the
corresponding pull request, including how we've resolved them in our
for-next branch.


Thanks,

-Olof

