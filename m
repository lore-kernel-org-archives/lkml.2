Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2IQQwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:52:13 -0400
Received: from mail.x86-64.org ([217.9.48.20]:53943 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2IQQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:52:09 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/2] Minimal RAS stuff
Date: Mon, 17 Sep 2012 18:52:01 +0200
Message-Id: <1347900723-17490-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Ok,

my main intention for this is patch 1/2 which enables MCA by default. I
still see bugreports where CONFIG_X86_MCE is disabled and this is a bad
idea so turning it on by default makes sense to me.

The second patch is only a cleanup.

Thanks.

Borislav Petkov (2):
  x86, mce: Enable MCA support by default
  x86, MCE: Remove unused defines

 arch/x86/Kconfig           |  1 +
 arch/x86/include/asm/mce.h | 12 +-----------
 2 files changed, 2 insertions(+), 11 deletions(-)

-- 
1.7.11.rc1

