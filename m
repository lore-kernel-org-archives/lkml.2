Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab0HKFRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 01:17:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0HKFRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 01:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Mk1eTM9njETOd/BFmcaC3nGKDw2seKQz5ClZLQz1ee2wMnDq06DCXsOnFV9jgD4EQ+
         1AvRaovYN2dCoHZ2fsXWnnf14Z+ZLPeaXhfuRdyDNETD1//SzvXTLI/QBLBc5FpXaAp2
         gmQ2626WZc2WZAn2IL+G+3wBgrElSEdWkmldA=
Date: Wed, 11 Aug 2010 09:17:10 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20100811051710.GA29157@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6.git tree to receive changes prepared
for 2.6.36.

Thanks!

The following changes since commit eb9650d6d989f24f21232a055d8fd45f1a9dcf99:
  Peter Huewe (1):
        ds2782_battery: Rename get_current to fix build failure / name conflict

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git master

Alan Cox (1):
      intel_mid_battery: Fix battery scaling

Arjan van de Ven (1):
      intel_mid_battery: Fix the argument order to intel_scu_ipc_command

David Woodhouse (1):
      olpc_battery: Fix build failure caused by sysfs changes

Nithish Mahalingam (1):
      Intel MID platform battery driver

Vasily Khoruzhick (1):
      Add s3c-adc-battery driver

 drivers/power/Kconfig             |   13 +
 drivers/power/Makefile            |    2 +
 drivers/power/intel_mid_battery.c |  799 +++++++++++++++++++++++++++++++++++++
 drivers/power/olpc_battery.c      |    3 +-
 drivers/power/s3c_adc_battery.c   |  431 ++++++++++++++++++++
 include/linux/s3c_adc_battery.h   |   36 ++
 6 files changed, 1282 insertions(+), 2 deletions(-)
 create mode 100644 drivers/power/intel_mid_battery.c
 create mode 100644 drivers/power/s3c_adc_battery.c
 create mode 100644 include/linux/s3c_adc_battery.h
