Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab2JAX7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:59:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53219 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab2JAX5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:34 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: =?UTF-8?q?=5BGIT=20PULL=203/12=5D=20ARM=3A=20soc=3A=20MAINTAINERS=20updates?=
Date: Mon,  1 Oct 2012 16:56:58 -0700
Message-Id: <1349135827-24790-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintainers updates for KS8965 adding Greg Ungerer, and removing
myself and Colin Cross as tegra maintainers, since Stephen Warren has
been handling it on his own for several releases now.


Conflicts: none

----------------------------------------------------------------

The following changes since commit ed0a0ed0a4e0e6eeebfa154f97ebb41abc5bbee8:

  Merge branch 'next/cleanup' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/maintainers

for you to fetch changes up to d192f93cfca6a0aedbf10fa548d8bc17b86275d6:

  Merge tag 'tegra-for-3.7-maintainers' of git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra into next/maintainers

----------------------------------------------------------------

Arnd Bergmann (1):
      ARM: ks8695: add maintainers entry

Olof Johansson (1):
      Merge tag 'tegra-for-3.7-maintainers' of git://git.kernel.org/.../swarren/linux-tegra into next/maintainers

Stephen Warren (1):
      MAINTAINERS: tegra: remove Olof/Colin, add device tree files

Uwe Kleine-König (1):
      MAINTAINERS: add defconfig file to TEGRA section


 MAINTAINERS | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)
