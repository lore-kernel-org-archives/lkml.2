Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1FDXAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 19:00:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1FDW77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 18:59:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rfuY+RgSDhJ14rmlj3pZY4Z1goNUZQdddAXiredskPLFxsHtsPMKk93FPeVdbdvmEt
         bBwG8aTCyd5RGjyXQ5tA==
MIME-Version: 1.0
Date: Sat, 4 Jun 2011 15:59:56 -0700
Message-ID: <BANLkTikqRkiRKVBsAfEmrO+O9m19KEMzBg@mail.gmail.com>
Subject: ARM Tegra fixes for 3.0-rc2
From: Colin Cross <ccross@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        lakml <linux-arm-kernel@lists-infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull one fix for Tegra from:

 git://android.git.kernel.org/kernel/tegra.git for-linus

Thanks,
Colin

The following changes since commit 55922c9d1b84b89cb946c777fddccb3247e7df2c:

  Linux 3.0-rc1 (2011-05-29 17:43:36 -0700)

are available in the git repository at:
  git://android.git.kernel.org/kernel/tegra.git for-linus

Stephen Warren (1):
      ARM: Tegra: Harmony: Fix conflicting GPIO numbering

 arch/arm/mach-tegra/board-harmony-power.c |    4 +++-
 arch/arm/mach-tegra/board-harmony.h       |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)
