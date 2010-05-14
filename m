Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0ENDSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 23:18:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:16791 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab0ENDSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 23:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="276985787"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 0/3] Convert KVM to use FPU API
Date: Fri, 14 May 2010 11:16:50 +0800
Message-Id: <1273807013-4792-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset based on Avi's FPU API patchset.

Sheng Yang (3):
  x86: Split fpu_save_init() to fpu_save() and fpu_clear()
  x86: Export FPU API for KVM use
  KVM: x86: Use FPU API

 arch/x86/include/asm/i387.h     |   73 ++++++++++++++++++++++++---------------
 arch/x86/include/asm/kvm_host.h |   18 +---------
 arch/x86/include/asm/xsave.h    |    3 ++
 arch/x86/kernel/i387.c          |    3 +-
 arch/x86/kernel/process.c       |    1 +
 arch/x86/kvm/x86.c              |   73 ++++++++++++---------------------------
 6 files changed, 74 insertions(+), 97 deletions(-)

