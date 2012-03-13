Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab2CMS7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:59:43 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:21480 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2CMS7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:59:42 -0400
From: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
Subject: [PATCH] bug fix for 42142
Date: Tue, 13 Mar 2012 11:59:27 -0700
Message-Id: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor change to weed out the intended loginfo messages.

Sathisha Nanjappa (1):
  mpt2sas: Corrected the constant in comparison to a hexadecimal.

 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
1.7.7.6

