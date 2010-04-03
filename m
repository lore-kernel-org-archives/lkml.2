Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0DCB3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:29:06 -0400
Received: from sous-sol.org ([216.99.217.87]:45699 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754679Ab0DCB27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:28:59 -0400
Message-Id: <20100403012751.834020949@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Fri, 02 Apr 2010 18:27:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: nhorman@tuxdriver.com, nhorman@redhat.com, vgoyal@redhat.com,
       hbabu@us.ibm.com, ebiederm@xmission.com,
       iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] AMD IOMMU kdump fix plus cleanups (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Series includes the following patches:

  x86/amd-iommu: enable iommu before attaching devices
  x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
  Revert "x86: disable IOMMUs on kernel crash"
  x86/amd-iommu: use for_each_pci_dev

First one is the primary bug fix.

v2
- add disable_iommus on failure path
- move removal of CMD_BUFFER_UNINITIALIZED to iommu_enable_command_buffer()
- fix ";;" typo in patch 2
- add Revert "x86: disable IOMMUs on kernel crash"
- add x86/amd-iommu: use for_each_pci_dev

thanks,
-chris
