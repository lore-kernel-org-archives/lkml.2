Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1KQV5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 16:57:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45360 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1KQV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:57:40 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH v2 0/2] Dummy HPAGE_* constants for !CONFIG_HUGETLB_PAGE
Date: Thu, 17 Nov 2011 13:57:28 -0800
Message-Id: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

After a, somewhat heated, discussion with David Rientjes, I think the
following approach will work.

The first patch adds HPAGE_SHIFT, needed by MIPS.

The second cleans up the exiting HPAGE_MASK and HPAGE_SIZE

David Daney (2):
  hugetlb: Provide a default HPAGE_SHIFT if !CONFIG_HUGETLB_PAGE
  hugetlb: Provide safer dummy values for HPAGE_MASK and HPAGE_SIZE

 include/linux/hugetlb.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

Cc: David Rientjes <rientjes@google.com>
-- 
1.7.2.3

