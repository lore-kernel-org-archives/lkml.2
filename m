Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab1EFVF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:05:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:25273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab1EFVFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:05:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="743474543"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, arnd@arndb.de, akpm@linux-foundation.org
Subject: Remove last BKL leftover: lock_depth
Date: Fri,  6 May 2011 14:05:24 -0700
Message-Id: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed the BKL task->lock_depth field was there with various users.
But they all don't need it anymore because the BKL is gone.
Fix up all the users and then finally remove the field.

This patchkit only removes code.

-Andi

