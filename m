Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab0KZQ2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:28:32 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40132 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0KZQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:28:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=czOoGAZWj73ys5TrSB5OEvppt3f6gyWlzWFAv+3ybOt9zPjbiucRQOFAFSwv4RYE+K
         pYPLWkd4tzf/doJE4iK/Rm/xvSg+ls/DPqIi4yI/AlAkVjTAGx7xvrlTdC1JYY1yjsSp
         ySmnhPF3675U0Ud0Pzjk+yshNjy2oFtlT4+EQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/2] little-endian bitops bugfixes
Date: Sat, 27 Nov 2010 01:28:37 +0900
Message-Id: <1290788919-5057-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The little-endian bitops patch series has been added to the -mm tree
recently. I found two problems so far.

Akinobu Mita (2):
  bitops: use find_first_zero_bit() instead of find_next_zero_bit(addr,
    size, 0)
  bitops: introduce CONFIG_GENERIC_FIND_LE_BIT

 arch/frv/Kconfig                |    4 ++++
 arch/h8300/Kconfig              |    4 ++++
 arch/m32r/Kconfig               |    4 ++++
 arch/microblaze/Kconfig         |    3 +++
 arch/mips/Kconfig               |    4 ++++
 arch/parisc/Kconfig             |    4 ++++
 arch/powerpc/Kconfig            |    4 ++++
 arch/sh/Kconfig                 |    3 +++
 arch/sparc/Kconfig              |    4 ++++
 arch/xtensa/Kconfig             |    3 +++
 include/asm-generic/bitops/le.h |    8 +++++---
 lib/Kconfig                     |    3 +++
 lib/Makefile                    |    1 +
 lib/find_next_bit.c             |    3 +++
 14 files changed, 49 insertions(+), 3 deletions(-)

-- 
1.7.3.2

