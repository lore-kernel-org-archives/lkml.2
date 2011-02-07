Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1BGSPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:15:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:11093 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1BGSPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:15:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,438,1291622400"; 
   d="scan'208";a="600260378"
From: jacob.jun.pan@linux.intel.com
To: LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        akpm@linux-foundation.org, rdunlap@xenotime.net
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v3] cgroup/freezer: add per freezer duty ratio control
Date: Mon,  7 Feb 2011 10:13:02 -0800
Message-Id: <1297102383-2658-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Changelog:
v3:	- added documentation

v2:
	- use read_u64/write_u64 instead of string read/write
	- use period in second instead of ms
	- renamed duty_ratio to duty_ratio_pct, be more specific
	- removed locking around period and duty_ratio reads


Jacob Pan (1):
  cgroup/freezer: add per freezer duty ratio control

 Documentation/cgroups/freezer-subsystem.txt |   23 ++++++
 kernel/cgroup_freezer.c                     |  109 ++++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 2 deletions(-)

