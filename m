Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1CVEZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 00:25:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:48127 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1CVEZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 00:25:22 -0400
Subject: [sound] !CONFIG_REGULATOR + CONFIG_SND_SOC_ALL_CODECS  ->
 CONFIG_SND_SOC_SGTL5000=m -> build failure
From: Mike Galbraith <mgalbraith@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Mar 2011 05:25:19 +0100
Message-ID: <1300767919.7483.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2.6.38-6671-geddecbb

marge:/usr/local/src/kernel/linux-2.6.39.git # make -j4 && make modules_install install
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  Building modules, stage 2.
Kernel: arch/x86/boot/bzImage is ready  (#1893)
  MODPOST 523 modules
ERROR: "rdev_get_drvdata" [sound/soc/codecs/snd-soc-sgtl5000.ko] undefined!
ERROR: "regulator_register" [sound/soc/codecs/snd-soc-sgtl5000.ko] undefined!
ERROR: "regulator_unregister" [sound/soc/codecs/snd-soc-sgtl5000.ko] undefined!
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

# CONFIG_REGULATOR is not set
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_SGTL5000=m


