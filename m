Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0I2Tao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:30:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46454 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0I2Tan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=VKUOJE+BWHJW3jYqEhE0AX4AQBp49UWbefdAeuGTnds9pJTQgZkB0cBP6yMBnDzjjj
         QkQ7G3dStdruCBqqqmBsmdWFiw0IF1R0exxiA4/taEOroIGPxYhv4sC/iysh/aaQeRG3
         VkHqjKCb+Rrvj0Rj21+QRmlOyJYyFWAhhE63U=
Subject: [PATCH 0/9] ARM: S3C64XX: real6410 and mini6410 patches for next
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Date: Wed, 29 Sep 2010 22:30:38 +0300
Message-ID: <20100929192354.25307.40197.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add more features for real6410
and support for new board mini6410 from FriendlyARM.
All new devices are tested on both boards. Frame buffer
is tested with 4.3" and 7.0" LCD displays on mini6410 and
with 7.0" LCD display only on real6410.

---

Darius Augulis (9):
      ARM: S3C64XX: add frame buffer support for mach-real6410
      ARM: S3C64XX: add nand support for mach-real6410
      ARM: S3C64XX: add touchscreen support for mach-real6410
      ARM: S3C64XX: add USB host support for mach-real6410
      ARM: S3C64XX: add support for mach-mini6410
      ARM: S3C64XX: add nand support for mach-mini6410
      ARM: S3C64XX: add frame buffer support for mach-mini6410
      ARM: S3C64XX: add backlight control for mach-mini6410
      ARM: S3C64XX: add touchscreen support for mach-mini6410


 arch/arm/mach-s3c64xx/Kconfig         |   21 ++
 arch/arm/mach-s3c64xx/Makefile        |    1 
 arch/arm/mach-s3c64xx/mach-mini6410.c |  360 +++++++++++++++++++++++++++++++++
 arch/arm/mach-s3c64xx/mach-real6410.c |  198 ++++++++++++++++++
 4 files changed, 575 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-s3c64xx/mach-mini6410.c

-- 

