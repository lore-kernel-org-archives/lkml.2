Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0LATHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:07:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:17885 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab0LATHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:07:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,284,1288594800"; 
   d="scan'208";a="632102299"
From: jacob.jun.pan@linux.intel.com
To: container cgroup <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [RFC PATCH 0/2] per cgroup timer slack and freezer duty cycle
Date: Wed,  1 Dec 2010 11:00:10 -0800
Message-Id: <1291230012-9536-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Hi,

These are two cgroup related patches for supporting power friendly
behavior of batch jobs in a cgroup.
The main usage is for managing background applications where more
relaxed timer rounding effect and reduced CPU time are desired.

Thanks,

Jacob

Jacob Pan (2):
  cgroup: add per cgroup timer_slack_ns
  cgroup/freezer: add per freezer duty ratio control

 include/linux/cgroup.h    |    1 +
 include/linux/init_task.h |    3 +-
 kernel/cgroup.c           |   43 ++++++++++++
 kernel/cgroup_freezer.c   |  157 ++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 201 insertions(+), 3 deletions(-)

