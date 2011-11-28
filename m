Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1K1Pm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:42:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54177 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1K1Pm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:42:58 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 00/11] checkpatch fixes
Date: Mon, 28 Nov 2011 15:42:42 +0000
Message-Id: <1322494973-29225-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After all the fun with kernel.org (and at least in part due to work
contraints) I have gotten behind on pushing out fixes for checkpatch.
Following this email are a bunch of patches I have had lying about for
some time.  There are a couple of optimisation for performance on some
outlying cases, plus a number of little fixes.

-apw

Andy Whitcroft (11):
  checkpatch: correctly track the end of preprocessor commands in context
  checkpatch: check for common memset parameter issues against statments
  checkpatch: ## is not a valid modifier
  checkpatch: optimise statement scanner when mid-statement
  checkpatch: only apply kconfig help checks for options which prompt
  checkpatch: fix EXPORT_SYMBOL handling following a function
  checkpatch: complex macro should allow the empty do while loop
  checkpatch: fix 'return is not a function' square bracket handling
  checkpatch: fix complex macros handling of square brackets
  checkpatch: ensure cast type is unique in the context parser
  checkpatch: typeof may have more complex arguments

 scripts/checkpatch.pl |  169 +++++++++++++++++++++++++++++--------------------
 1 files changed, 100 insertions(+), 69 deletions(-)

-- 
1.7.5.4

