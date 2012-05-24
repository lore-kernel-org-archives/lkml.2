Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab2EXSoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:44:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53233 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab2EXSoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:44:15 -0400
MIME-Version: 1.0
From: Matt Turner <mattst88@gmail.com>
Date: Thu, 24 May 2012 14:43:54 -0400
Message-ID: <CAEdQ38Eoifx-07VVGq=WDc5x929=AJo9iXoCs-X5RpwCeVx=fw@mail.gmail.com>
Subject: [PULL] alpha.git
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Michael Cree <mcree@orcon.net.nz>,
        linux-alpha <linux-alpha@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull from the for-linus branch of my alpha tree.

This pull adds the implementations of some Tru64 syscalls which allow
some proprietary software such as the C compiler to work on Linux.
Also, it adds some big-endian ioread functions to help us get closer
to building allyesconfig.

Thanks,
Matt

The following changes since commit f9369910a6225b8d4892c3f20ae740a711cd5ace:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal (2012-05-23
18:11:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha.git for-linus

Mans Rullgard (2):
      alpha: implement setsysinfo(SSI_LMF) as a no-op
      alpha: implement various OSF/1 stat syscalls

Michael Cree (1):
      alpha: add io{read,write}{16,32}be functions

 arch/alpha/include/asm/io.h      |    5 +
 arch/alpha/include/asm/sysinfo.h |    1 +
 arch/alpha/include/asm/unistd.h  |    6 ++
 arch/alpha/kernel/osf_sys.c      |  166 ++++++++++++++++++++++++++++++++++++++
 arch/alpha/kernel/systbls.S      |   10 +-
 5 files changed, 183 insertions(+), 5 deletions(-)
