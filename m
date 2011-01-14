Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1ANSAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:00:31 -0500
Received: from mail.atmel.fr ([81.80.104.162]:50759 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1ANSA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:00:29 -0500
Message-ID: <4D308F30.6070503@atmel.com>
Date: Fri, 14 Jan 2011 19:00:16 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Igor Plyatov <plyatov@gmail.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Subject: [GIT PULL] AT91: patches for v2.6.38-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Can you please pull those little changes for AT91? They add two 
new boards already discussed on the mailing list and a little 
cleanup patch:

The following changes since commit 9e9bc9736756f25d6c47b4eba0ebf25b20a6f153:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 (2011-01-06 18:32:12 -0800)

are available in the git repository at:

  git://github.com/at91linux/linux-2.6-at91.git for_rmk

Igor Plyatov (1):
      AT91: Support for gsia18s board

Jesper Juhl (1):
      AT91: board-sam9m10g45ek.c: Remove duplicate inclusion of mach/hardware.h

Sergio Tanzilli (1):
      AT91: Acme Systems FOX Board G20 board files

 arch/arm/mach-at91/Kconfig                |   13 +
 arch/arm/mach-at91/Makefile               |    2 +
 arch/arm/mach-at91/board-foxg20.c         |  274 ++++++++++++++
 arch/arm/mach-at91/board-gsia18s.c        |  584 +++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9m10g45ek.c   |    1 -
 arch/arm/mach-at91/include/mach/gsia18s.h |   33 ++
 6 files changed, 906 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-at91/board-foxg20.c
 create mode 100644 arch/arm/mach-at91/board-gsia18s.c
 create mode 100644 arch/arm/mach-at91/include/mach/gsia18s.h

Thanks, best regards,
-- 
Nicolas Ferre
