Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2JCWYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:24:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:22776 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab2JCWYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:24:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,529,1344236400"; 
   d="scan'208";a="230226803"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Resubmitting 1GB page shm patchkit
Date: Wed,  3 Oct 2012 15:24:22 -0700
Message-Id: <1349303063-12766-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchkit allows to specify 1GB (and other) page sizes with
shmget(). This is useful for programs who are difficult to modify
to use mmap.

I got positive reviews last time I submitted this. I also get 
requests from various users who want it. So here's a resend with:

- Rebased to current mainline
- Retested
- Fixed a minor umount problem.

Please consider for merging.

-Andi


