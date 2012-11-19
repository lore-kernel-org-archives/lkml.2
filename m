Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2KSOqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:46:01 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35830 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:46:00 -0500
Message-ID: <50AA4621.20509@gmail.com>
Date: Mon, 19 Nov 2012 08:45:53 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "arm@kernel.org" <arm@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Calxeda cpuidle support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

Please pull cpuidle support for highbank. This is the first driver in
drivers/cpuidle. All the existing drivers for ARM are in arch/arm. I'm
asking for you to pull since there seems to be a lack of maintainer for
cpuidle drivers.

Regards,
Rob

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git tags/highbank-cpuidle

for you to fetch changes up to be6a98d3f00c292d347465d96acbec9d8c2783cf:

  cpuidle: add Calxeda SOC idle support (2012-11-07 17:15:36 -0600)

----------------------------------------------------------------
Add cpuidle driver support for Calxeda Highbank SOC.

----------------------------------------------------------------
Rob Herring (1):
      cpuidle: add Calxeda SOC idle support

 drivers/cpuidle/Kconfig           |   10 +++
 drivers/cpuidle/Makefile          |    2 +
 drivers/cpuidle/cpuidle-calxeda.c |  161
+++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)
 create mode 100644 drivers/cpuidle/cpuidle-calxeda.c
