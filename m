Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab2CAMoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 07:44:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50801 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2CAMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:44:24 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/5] checkpatch update
Date: Thu,  1 Mar 2012 12:44:05 +0000
Message-Id: <1330605850-7873-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, here a a few patches I have sitting in my tree.  A small
collections of improvements for false positives.

They pass all the tests I have.

Thanks.

-apw

Andy Whitcroft (5):
  checkpatch: catch [ ... ] usage when not at the beginning of defination
  checkpatch: allow simple character constants in #defines
  checkpatch: handle string concatenation in simple #defines
  checkpatch: high precidence operators do not require additional
    parentheses in #defines
  checkpatch: add [] to type extensions

 scripts/checkpatch.pl |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

-- 
1.7.9

