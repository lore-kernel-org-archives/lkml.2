Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2BCOUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:20:13 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:22215 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab2BCOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:20:11 -0500
Message-ID: <4F2BED06.9@atmel.com>
Date: Fri, 03 Feb 2012 15:19:50 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: pm cleanup for standby
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an AT91 power management cleanup done recently by Daniel Lezcano. This series goes on top of the pull request that I have just sent (at91-3.4-base branch).

Here is the diffstat from the "CAP9 removal" commit that lies in the at91-3.4-base branch.


The following changes since commit 9918ceafd4a9e013572e03983f528017c29bb1cb:

  ARM: at91: code removal of CAP9 SoC (2012-02-03 13:33:05 +0100)

are available in the git repository at:
  git://github.com/at91linux/linux-at91.git at91-3.4-base+pm_cleanup

Daniel Lezcano (4):
      ARM: at91: coding style fixes
      ARM: at91: declare header name
      ARM: at91: remove wait_for_interrupt definition
      ARM: at91: implement the standby function for pm/cpuidle

 arch/arm/mach-at91/cpuidle.c |   11 ++----
 arch/arm/mach-at91/pm.c      |   12 +------
 arch/arm/mach-at91/pm.h      |   73 +++++++++++++++++++++++++++---------------
 3 files changed, 51 insertions(+), 45 deletions(-)

Thanks, best regards,
-- 
Nicolas Ferre
