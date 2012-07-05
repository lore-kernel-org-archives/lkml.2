Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2GENLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab2GENLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:11:22 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 0/2] hypervisor, update hypervisor_x86 entries for kvm and xen
Date: Thu,  5 Jul 2012 09:11:15 -0400
Message-Id: <1341493877-16622-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to help with debugging, add a hypervisor_x86 for kvm, and properly
export the xen hypervisor_x86.

Prarit Bhargava (2):
  kvm, Add x86_hyper_kvm to complete detect_hypervisor_platform check
    [v2]
  xen, fix x86_hyper_xen_hvm symbol export

 arch/x86/include/asm/hypervisor.h |    1 +
 arch/x86/kernel/cpu/hypervisor.c  |    1 +
 arch/x86/kernel/kvm.c             |   14 ++++++++++++++
 arch/x86/xen/enlighten.c          |    2 +-
 4 files changed, 17 insertions(+), 1 deletion(-)

-- 
1.7.9.3

