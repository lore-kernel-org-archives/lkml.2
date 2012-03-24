Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2CXWEC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:04:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61335 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab2CXWDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:03:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 02/09] ARM: subarch maintainer updates
Date: Sat, 24 Mar 2012 22:02:40 +0000
Message-Id: <1332626568-17812-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332626568-17812-1-git-send-email-arnd@arndb.de>
References: <1332626568-17812-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:exDrrxwbLLG4mFu0EgLMZo1kCQj3JZnMyDOdpEx/xub
 Em51+VYMPxdJSqnN9bWueA5++0i/9G45PWMtBmucRINquOKVrO
 rEPHzTjmK5x3x034GRJ+6OVj7eERShsNX9IEo3/qICISBBAEQT
 /VRLmlUyDXoQOJ4vicB3dVB6qQh5Lhvc42CRuXx98P2nkGFO+w
 pUOlEGauNUjp2Bxx7GtTClWJrEdtRuDazz0k6ncTHalpTQWl4Z
 HUsHk1cDz8dkkjXw3HTJy7B5FnaIC1RIygNEXDMoTd+xUdf7Jq
 sgCzXScFtOKUkV2T70AAZbrxIsOh8lhQ4B79F2grD4D9UYKjKl
 MOX7JTteCVAiE5FU0eq3QQgBMrNikXr8wnxAAe1YfLRRbUmemh
 2lUf7tNr+XV6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a collection of updates to the MAINTAINERS file, separated out
mostly to give an overview of what has changed regarding who does what.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

The following changes since commit "947a21c Merge branch
'next/maintainers' into for-next", leading up to commit " fd117cd ARM:
tegra: update main repo and add patchwork", are available in

git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/maintainers

Arnd Bergmann (2):
      Merge branch 'fixes-non-critical' of git://github.com/hzhuang1/linux into next/maintainers
      Merge branch 'next/maintainers' into for-next

Haojian Zhuang (1):
      MAINTAINERS: update MAINTAINERS email entry

Olof Johansson (2):
      Merge branch 'maintainers' of git://gitorious.org/linux-davinci/linux-davinci into next/maintainers
      ARM: tegra: update main repo and add patchwork

Philipp Zabel (1):
      MAINTAINERS: update maintainer entry for pxa/hx4700

Sekhar Nori (2):
      MAINTAINERS: mark TI DaVinci list as "moderated"
      MAINTAINERS: add TI DaVinci git tree information

Shawn Guo (1):
      MAINTAINERS: remove arch/arm/mach-mx*/ from IMX entry

Stephen Warren (1):
      MAINTAINERS: ARM: tegra: update Stephen's email address


 MAINTAINERS |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)
