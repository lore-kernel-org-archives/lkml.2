Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1DNFvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 01:51:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36259 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab1DNFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 01:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=prsm/r+yuQdPfpzLcFZXhWFqpRQXz/D6tYuDF7wdONyl5EhtqGGAl7+nKpXB54oebH
         wMBX5w1AeXgfqQk7YW6Q==
MIME-Version: 1.0
Date: Wed, 13 Apr 2011 22:50:58 -0700
Message-ID: <BANLkTimtnD3OMWT11Kf4A8dyx=Vp9DOOGQ@mail.gmail.com>
Subject: ARM Tegra fixes for 2.6.39-rc4
From: Colin Cross <ccross@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Tegra Mailing List <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@google.com>, Olof Johansson <olofj@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull minor fixes for Tegra from:

 git://android.git.kernel.org/kernel/tegra.git for-linus

Thanks,
Colin


The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://android.git.kernel.org/kernel/tegra.git for-linus

Colin Cross (1):
      ARM: tegra: gpio: Fix unused variable warnings

Nicolas Kaiser (1):
      arm: tegra: fix error check in tegra2_clocks.c

 arch/arm/mach-tegra/gpio.c          |    6 ++++--
 arch/arm/mach-tegra/tegra2_clocks.c |    9 +++++----
 2 files changed, 9 insertions(+), 6 deletions(-)
