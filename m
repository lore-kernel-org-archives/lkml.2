Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab2J3ShS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:37:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45244 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2J3ShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:37:12 -0400
From: Behan Webster <behanw@converseincode.com>
To: herbert@gondor.hengli.com.au, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH 0/2] Removing the use of VLAIS from the Linux Kernel
Date: Tue, 30 Oct 2012 14:37:27 -0400
Message-Id: <1351622249-18084-1-git-send-email-behanw@converseincode.com>
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

Jan-Simon Möller (2):
  Remove VLAIS usage from crypto/hmac.c
  Remove VLAIS usage from crypto/testmgr.c

 crypto/hmac.c    |   27 +++++++++++++--------------
 crypto/testmgr.c |   23 +++++++++++++----------
 2 files changed, 26 insertions(+), 24 deletions(-)

-- 
1.7.9.5

