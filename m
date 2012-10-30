Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab2J3Smk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:42:40 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54614 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2J3Smi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:42:38 -0400
From: Behan Webster <behanw@converseincode.com>
To: davem@davemloft.net
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 0/2] Removing the use of VLAIS from netfilter
Date: Tue, 30 Oct 2012 14:42:52 -0400
Message-Id: <1351622574-18421-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Behan Webster (1):
  Helper macros used for replacing the use of VLAIS

Jan-Simon Möller (1):
  Remove VLAIS usage from netfilter

 include/linux/valign.h      |   87 +++++++++++++++++++++++++++++++++++++++++++
 net/netfilter/xt_repldata.h |   40 ++++++++++++--------
 2 files changed, 111 insertions(+), 16 deletions(-)
 create mode 100644 include/linux/valign.h

-- 
1.7.9.5

