Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1G1L2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 07:28:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57115 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab1G1L2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 07:28:41 -0400
From: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Subject: [PATCH 0/2] PCI driver to use insert_resource_conflict() to claim resources
Date: Thu, 28 Jul 2011 19:28:30 +0800
Message-Id: <1311852512-7340-1-git-send-email-dengcheng.zhu@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use insert_resource_conflict() instead of request_resource_conflict() in
pci_claim_resource() to work with the conflict resource which can be the parent
of the resource to be claimed.

Deng-Cheng Zhu (2):
  PCI: make pci_claim_resource() work with conflict resources as
    appropriate
  kernel/resource: enrich the comment for insert_resource_conflict()

 drivers/pci/setup-res.c |    2 +-
 kernel/resource.c       |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

