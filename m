Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549Ab2BNN1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 08:27:50 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49352 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384Ab2BNN1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 08:27:49 -0500
MIME-Version: 1.0
Date: Tue, 14 Feb 2012 14:27:48 +0100
Message-ID: <CAFLxGvwKJ+19+Lj6O=ZJWAgeJr=1dX_nQzd7fPmv-Rw4eUagrw@mail.gmail.com>
Subject: ppc64: allyesconfig fails: ld: TOC section size exceeds 64k
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: benh@kernel.crashing.org, paulus@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Building an allyesconfig fails on ppc64:
LD      vmlinux.o
ld: TOC section size exceeds 64k
make: *** [vmlinux.o] Fehler 1

Is this a known problem?
Kernel version is Linus' tree as of today.

gcc-Version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC)

-- 
Thanks,
//richard
