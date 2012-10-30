Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398Ab2J3SZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:25:15 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:60130 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378Ab2J3SZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:25:07 -0400
From: Behan Webster <behanw@converseincode.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 0/2] Removing the use of VLAIS from the Linux Kernel
Date: Tue, 30 Oct 2012 14:25:18 -0400
Message-Id: <1351621520-17768-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
precludes the use of compilers which don't implement VLAIS (for instance the
Clang compiler). The LLVMLinux Project is working towards the ability of
providing the Linux kernel developer the choice of using the Clang compiler
toolchain. This is a part of a series of patches which remove the use of VLAIS
from crypto code, dm-crypt, jbd2, libcrc32c, netfilter, and usb gadget. Other
patches to allow Clang to be used will follow.

Behan Webster (2):
  Helper macros used for replacing the use of VLAIS
  Remove VLAIS usage from gadget code

 drivers/usb/gadget/f_fs.c |  106 ++++++++++++++++++++++++++-------------------
 include/linux/valign.h    |   87 +++++++++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 45 deletions(-)
 create mode 100644 include/linux/valign.h

-- 
1.7.9.5

