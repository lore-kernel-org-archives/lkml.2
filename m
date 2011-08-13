Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab1HMEPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 00:15:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41807 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HMEPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 00:15:05 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 12 Aug 2011 22:14:43 -0600
X-Google-Sender-Auth: GVz7tOlsjcAHGkbsVGsDMcXyle8
Message-ID: <CACxGe6vU5iqwJ5tcYmAKyHVYUDkiNWtTfGCnGFQrFwMdU7qXrg@mail.gmail.com>
Subject: [GIT PULL] devicetree bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <SWarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's one patch needed to fix a bug in the Tegra i2c driver.

Thanks,
g.

The following changes since commit d55140ce3a7b36241171bd78c75a5ee85de20439:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6
(2011-08-10 11:08:06 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Stephen Warren (1):
      dt: add empty of_get_property for non-dt

 include/linux/of.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
