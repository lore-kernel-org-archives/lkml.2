Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1A0Flr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:41:47 -0500
Received: from smtp-out.google.com ([74.125.121.67]:36651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1A0Flp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:41:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=C9ztY/ZItuR/GYPL1BN0xkC56T/F7sxZsQrEbDwGOFPJzGstgjeH6TM79C5iaf39dN
         tbw+IPqPZ1UkqkQhRI3w==
MIME-Version: 1.0
Date: Wed, 26 Jan 2011 21:41:40 -0800
Message-ID: <AANLkTim6zcdn8FgUTa7OO=_4B3x5CiHxWr_g=uR0m4zX@mail.gmail.com>
Subject: [GIT PULL] ARM Tegra fixes for 2.6.38
From: Colin Cross <ccross@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Tegra Mailing List <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull fixes for the Tegra machine from:

  http://android.git.kernel.org/kernel/tegra.git for-linus

Thanks,
Colin

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  http://android.git.kernel.org/kernel/tegra.git for-linus

Colin Cross (2):
      ARM: tegra: irq: Rename gic pointers to avoid conflicts
      ARM: tegra: clock: Add forward reference to struct clk

Grant Likely (1):
      arm/tegra: Fix tegra irq_data conversion

 arch/arm/mach-tegra/gpio.c                |    4 ++--
 arch/arm/mach-tegra/include/mach/clk.h    |    2 ++
 arch/arm/mach-tegra/include/mach/clkdev.h |    2 ++
 arch/arm/mach-tegra/irq.c                 |   18 +++++++++---------
 4 files changed, 15 insertions(+), 11 deletions(-)
