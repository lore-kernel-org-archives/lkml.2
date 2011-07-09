Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1GITlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 15:41:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44495 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1GITlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 15:41:44 -0400
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
To: fengguang.wu@intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Raghavendra D Prabhu <rprabhu@wnohang.net>
Subject: [PATCH 0/3] Readahead fixes
Date: Sun, 10 Jul 2011 01:11:17 +0530
Message-Id: <cover.1310239575.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor readahead fixes, details in respective patch mails

Raghavendra D Prabhu (3):
  Change the check for PageReadahead into an else-if
  Remove file_ra_state from arguments of count_history_pages.
  Move the check for ra_pages after VM_SequentialReadHint()

 mm/filemap.c   |    8 ++++----
 mm/readahead.c |    3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

-- 
1.7.6

