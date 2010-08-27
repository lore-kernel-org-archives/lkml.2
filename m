Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0H0DkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 23:40:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26869 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab0H0DkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 23:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xqtG4aUUwqhJvjW4Fawa2z+l52+KZrVYUAPC+K86eSFCF3act/sws3UU1a6VqZibhT
         aTotvnxxh+ptbW1LJoQg==
MIME-Version: 1.0
Date: Thu, 26 Aug 2010 20:40:10 -0700
Message-ID: <AANLkTi==Z-SbfSWBhxoZMpKLtCwA9O_oUgh8PWrMNRoG@mail.gmail.com>
Subject: [GIT PULL] tegra fixes for 2.6.36
From: Colin Cross <ccross@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull tegra fixes from:

git://android.git.kernel.org/kernel/tegra.git for-linus

Thanks,
Colin

The following changes since commit d4348c678977c7093438bbbf2067c49396ae941b:
  Linus Torvalds (1):
        Merge branch 'perf-fixes-for-linus' of
git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://android.git.kernel.org/kernel/tegra.git for-linus

Olof Johansson (2):
      arm: tegra: fix compilation of board-harmony.c
      arm: tegra: VMALLOC_END should be unsigned long

 arch/arm/mach-tegra/board-harmony.c        |    2 --
 arch/arm/mach-tegra/include/mach/vmalloc.h |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)
