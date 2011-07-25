Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1GYP5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:57:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33808 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1GYP5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:57:10 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 25 Jul 2011 09:56:50 -0600
X-Google-Sender-Auth: xo3qd-yvMA52cU0YMJox6qZgjS0
Message-ID: <CACxGe6s8uDd_3+QyE7G5CetL0XySMZhCgg_NEn2PBRxDsGWcnA@mail.gmail.com>
Subject: [GIT PULL] Basic arm device tree support patches for v3.1
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Here are some of the basic DT patches that are needed for arm in v3.1.
 This isn't board support yet (need an ack on irq_domain first), but
it is some of the prerequisites.

g.

The following changes since commit b6844e8f64920cdee620157252169ba63afb0c89:

  Merge branch 'for-linus' of
master.kernel.org:/home/rmk/linux-2.6-arm (2011-07-24 10:20:54 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/next-arm

Grant Likely (2):
      arm/dt: Add dt machine definition
      arm/dt: Add skeleton dtsi file

Rob Herring (1):
      arm/dt: Add dtb make rule

 arch/arm/Makefile                |    7 +++++++
 arch/arm/boot/Makefile           |    6 ++++++
 arch/arm/boot/dts/skeleton.dtsi  |   13 +++++++++++++
 arch/arm/include/asm/mach/arch.h |    7 +++++++
 4 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/skeleton.dtsi


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
