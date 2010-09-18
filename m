Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0IRPxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 11:53:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59275 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0IRPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 11:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wHcS44/8mg/hrdCRG8bULF1+IgPqr9VRqoeewGk6PNlv69a9WKbJmO4Ha8RIHB/dn8
         QamnRN0UruYApNGuc3zvoIZD2uoaroOCvCA0qZ25N4gFogRITS1/J7LOWLFrShAyK/2n
         G3gUD32pxw78G/fSWRwM2h5UCVsVf6gV5zUhg=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] printk cleanups
Date: Sun, 19 Sep 2010 00:52:58 +0900
Message-Id: <1284825182-32588-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to remove sparse warnings on printk routines.
All patches in this series are simple, one-liner and don't waste
your time much. Please take a look and consider applying it. :-)

Thanks.

---
Namhyung Kim (4):
  printk: Fixup declaration of kmsg_reasons
  printk: Add lock context annotation
  printk: Change type of 'boot_delay' to int *
  printk: Declare printk_ratelimit_state in ratelimit.h

 include/linux/ratelimit.h |    4 ++++
 kernel/printk.c           |    5 +++--
 kernel/sysctl.c           |    2 --
 3 files changed, 7 insertions(+), 4 deletions(-)

