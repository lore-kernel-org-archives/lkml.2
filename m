Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2LQKtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 05:49:43 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62794 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2LQKtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 05:49:42 -0500
MIME-Version: 1.0
In-Reply-To: <20121217031937.D6BEF6606E7@gitolite.kernel.org>
References: <20121217031937.D6BEF6606E7@gitolite.kernel.org>
Date: Mon, 17 Dec 2012 11:49:40 +0100
X-Google-Sender-Auth: KqHH5Do0V4p1w9nJ9H62HVhG4QA
Message-ID: <CAMuHMdVV4mcGqzkEjyNxor=j+8p8u5uu3-h8-YN-HQrkp7y5TQ@mail.gmail.com>
Subject: Fwd: mfd: Remove Unicode Byte Order Marks from da9055
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: stable@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 3.7


---------- Forwarded message ----------
From: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, Dec 17, 2012 at 4:19 AM
Subject: mfd: Remove Unicode Byte Order Marks from da9055
To: git-commits-head@vger.kernel.org


Gitweb:     http://git.kernel.org/linus/;a=commit;h=90a38d999739f35f4fc925c875e6ee518546b66c
Commit:     90a38d999739f35f4fc925c875e6ee518546b66c
Parent:     b851c06c241d4a2e43ee6007705765a9b1b3abb7
Author:     Geert Uytterhoeven <geert@linux-m68k.org>
AuthorDate: Mon Oct 15 22:44:45 2012 +0200
Committer:  Samuel Ortiz <sameo@linux.intel.com>
CommitDate: Mon Nov 12 00:54:57 2012 +0100

    mfd: Remove Unicode Byte Order Marks from da9055

    Older gcc (< 4.4) doesn't like files starting with Unicode BOMs:

    include/linux/mfd/da9055/core.h:1: error: stray ‘\357’ in program
    include/linux/mfd/da9055/core.h:1: error: stray ‘\273’ in program
    include/linux/mfd/da9055/core.h:1: error: stray ‘\277’ in program
    include/linux/mfd/da9055/pdata.h:1: error: stray ‘\357’ in program
    include/linux/mfd/da9055/pdata.h:1: error: stray ‘\273’ in program
    include/linux/mfd/da9055/pdata.h:1: error: stray ‘\277’ in program
    include/linux/mfd/da9055/reg.h:1: error: stray ‘\357’ in program
    include/linux/mfd/da9055/reg.h:1: error: stray ‘\273’ in program
    include/linux/mfd/da9055/reg.h:1: error: stray ‘\277’ in program

    Remove the BOMs, the rest of the files is plain ASCII anyway.

    Output of "file" before:

    include/linux/mfd/da9055/core.h:  UTF-8 Unicode (with BOM) C program text
    include/linux/mfd/da9055/pdata.h: UTF-8 Unicode (with BOM) C program text
    include/linux/mfd/da9055/reg.h:   UTF-8 Unicode (with BOM) C program text

    Output of "file" after:

    include/linux/mfd/da9055/core.h:  ASCII C program text
    include/linux/mfd/da9055/pdata.h: ASCII C program text
    include/linux/mfd/da9055/reg.h:   ASCII C program text

    Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/linux/mfd/da9055/core.h  |    2 +-
 include/linux/mfd/da9055/pdata.h |    2 +-
 include/linux/mfd/da9055/reg.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/da9055/core.h b/include/linux/mfd/da9055/core.h
index c96ad68..956afa4 100644
--- a/include/linux/mfd/da9055/core.h
+++ b/include/linux/mfd/da9055/core.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * da9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.
diff --git a/include/linux/mfd/da9055/pdata.h b/include/linux/mfd/da9055/pdata.h
index 147293b..b9b204e 100644
--- a/include/linux/mfd/da9055/pdata.h
+++ b/include/linux/mfd/da9055/pdata.h
@@ -1,4 +1,4 @@
-﻿/* Copyright (C) 2012 Dialog Semiconductor Ltd.
+/* Copyright (C) 2012 Dialog Semiconductor Ltd.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/include/linux/mfd/da9055/reg.h b/include/linux/mfd/da9055/reg.h
index df237ee..2b592e0 100644
--- a/include/linux/mfd/da9055/reg.h
+++ b/include/linux/mfd/da9055/reg.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * DA9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.
--
To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
