Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1F3SOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:14:44 -0400
Received: from mail.perches.com ([173.55.12.10]:3371 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1F3SOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:14:41 -0400
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dynamic_debug
Date: Thu, 30 Jun 2011 11:14:33 -0700
Message-Id: <cover.1309457340.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <20110630163218.GA2457@redhat.com>
References: <20110630163218.GA2457@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some improvements and cleanups to dynamic_debug

btw Jason:

You're not listed in MAINTAINERS for dynamic_debug.[ch].
Maybe you should add yourself. 

Joe Perches (4):
  dynamic_debug: Add __dynamic_dev_dbg
  dynamic_debug: Consolidate prefix output to single routine
  dynamic_debug: Remove uses of KERN_CONT in dynamic_emit_prefix
  dynamic_debug: Convert printks to pr_<level>

 drivers/base/core.c           |    5 +-
 include/linux/device.h        |    5 ++
 include/linux/dynamic_debug.h |   10 +++-
 lib/dynamic_debug.c           |  133 +++++++++++++++++++++++++++--------------
 4 files changed, 103 insertions(+), 50 deletions(-)

-- 
1.7.6.rc1

