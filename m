Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab1EaIxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:53:35 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:49835 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152Ab1EaIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:53:34 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 0/3] Add drivers/pwm and drivers/pwm/st_pwm.c
Date: Tue, 31 May 2011 14:21:50 +0530
Message-ID: <cover.1306831238.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds drivers/pwm directory as suggested by Arnd Bergmann in
following discussion:

http://comments.gmane.org/gmane.linux.ports.arm.kernel/118651

and also adds support for ST Microelectronics Pulse Width Modulator. This is
currently used by ST's SPEAr platform and tested on the same.

Changes since V1:
 - Moved driver to drivers/pwm/ directory from drivers/misc
 - arch/arm/configs/spear3xx_defconfig updated accordingly.

Changes since earlier patchset:
 - Moved driver to drivers/misc/ directory.

It was earlier reviewed as part of following patchset:
"[PATCH V6 00/17] Adding devices support for all spear machines"

Viresh Kumar (3):
  drivers/pwm st_pwm: Add support for ST's Pulse Width Modulator
  SPEAr3xx: Add machine support for ST's PWM IP
  SPEAr3xx: Update defconfig for ST's PWM

 MAINTAINERS                                   |    5 +
 arch/arm/configs/spear3xx_defconfig           |    2 +
 arch/arm/mach-spear3xx/include/mach/generic.h |    1 +
 arch/arm/mach-spear3xx/spear320.c             |   16 +
 arch/arm/mach-spear3xx/spear320_evb.c         |    1 +
 drivers/Kconfig                               |    1 +
 drivers/Makefile                              |    1 +
 drivers/pwm/Kconfig                           |   22 ++
 drivers/pwm/Makefile                          |    5 +
 drivers/pwm/st_pwm.c                          |  486 +++++++++++++++++++++++++
 10 files changed, 540 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pwm/Kconfig
 create mode 100644 drivers/pwm/Makefile
 create mode 100644 drivers/pwm/st_pwm.c

-- 
1.7.2.2

