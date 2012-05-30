Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2E3Iwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 04:52:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57779 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab2E3Iwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 04:52:51 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@google.com>,
        Dave Jones <davej@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        hughd@google.com
Subject: 
Date: Wed, 30 May 2012 04:52:32 -0400
Message-Id: <1338367958-21442-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


KOSAKI Motohiro (6):
  Revert "mm: mempolicy: Let vma_merge and vma_split handle
    vma->vm_policy linkages"
  mempolicy: Kill all mempolicy sharing
  mempolicy: fix a race in shared_policy_replace()
  mempolicy: fix refcount leak in mpol_set_shared_policy()
  mempolicy: fix a memory corruption by refcount imbalance in
    alloc_pages_vma()
  MAINTAINERS: Added MEMPOLICY entry

 MAINTAINERS    |    7 +++
 mm/mempolicy.c |  151 ++++++++++++++++++++++++++++++++++++++++----------------
 mm/shmem.c     |    9 ++--
 3 files changed, 120 insertions(+), 47 deletions(-)

