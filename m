Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2KVWEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:04:35 -0500
Received: from mga06.intel.com ([134.134.136.21]:43050 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757568Ab2KVWEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:04:31 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ima: policy search speedup
Date: Thu, 22 Nov 2012 23:54:42 +0200
Message-Id: <cover.1353621075.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is two patches for policy search speedup.

First patch adds additional features flags to superblock.
Second - implementation for IMA.

Two months ago I was asking about it on mailing lists.
Suggestion was not to use s_flags, but e.g. s_feature_flags.

Any objections about such approach?

Thanks,
Dmitry

Dmitry Kasatkin (2):
  vfs: new super block feature flags attribute
  ima: skip policy search for never appraised or measured files

 include/linux/fs.h                  |    4 ++++
 security/integrity/ima/ima_api.c    |    8 ++------
 security/integrity/ima/ima_policy.c |   20 +++++++++++++++++---
 security/integrity/integrity.h      |    3 +++
 4 files changed, 26 insertions(+), 9 deletions(-)

-- 
1.7.10.4

