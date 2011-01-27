Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1A0Nzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:55:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47979 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1A0Nzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:55:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cvT0r64dnb/ZWikaTcYoaUoibuCLSEpQT9A6Er39Uz8SCdGMQ6CxhNbWkRHsJYGm9v
         3aIZZmSO9Y1Pnh3Tp1UcCXGKLCT3GMhjQdUT0nVMXtXE65xKnwrP3kEqinfnazeOZ4nA
         zBeNzHAeM46GZ2P9LcBk96iNSSnP6jy2uQXf8=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -mm 0/6] convert little-endian bitops macros to inline functions
Date: Thu, 27 Jan 2011 22:56:17 +0900
Message-Id: <1296136583-13815-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The little-endian bitops patch series has been added to the -mm tree.
This additional patch series converts all little-endian bitops macros
to static inline functions with proper prototypes.

Akinobu Mita (6):
  asm-generic: convert little-endian bitops macros to static inline
    functions
  powerpc: convert little-endian bitops macros to static inline
    functions
  s390: convert little-endian bitops macros to static inline functions
  arm: convert little-endian bitops macros to static inline functions
  m68k: convert little-endian bitops macros to static inline functions
  m68knommu: convert little-endian bitops macros to static inline
    functions

 arch/arm/include/asm/bitops.h     |   70 +++++++++++++++++++++++++----------
 arch/m68k/include/asm/bitops_mm.h |   41 +++++++++++++++------
 arch/m68k/include/asm/bitops_no.h |   12 ++++--
 arch/powerpc/include/asm/bitops.h |   43 +++++++++++++++-------
 arch/s390/include/asm/bitops.h    |   48 +++++++++++++++++-------
 include/asm-generic/bitops/le.h   |   73 ++++++++++++++++++++++++++-----------
 6 files changed, 201 insertions(+), 86 deletions(-)

-- 
1.7.3.4

