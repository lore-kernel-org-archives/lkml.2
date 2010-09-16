Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0IPMLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:11:48 -0400
Received: from mail.perches.com ([173.55.12.10]:2081 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0IPMLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:11:13 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] scripts/get_maintainer.pl: Update to 0.25
Date: Thu, 16 Sep 2010 05:11:07 -0700
Message-Id: <cover.1284636516.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some miscellaneous improvements to the script.  Please apply.

Command line option changes:
--git-fallback is added and becomes the default
--git is no longer a default
--git-blame --rolestats shows "authored lines"

The default option changes reduces the number of people cc'd on patches when
a maintainer exists for particular files, but not necessarily the files in
subdirectories of patterns like "F: net/" or "F: arch/arm/".

Joe Perches (5):
  scripts/get_maintainer.pl: Add --git-blame --rolestats "Authored lines" information
  scripts/get_maintainer.pl: Use correct indentation
  scripts/get_maintainer.pl: Don't search MAINTAINERS for keywords or emails
  scripts/get_maintainer.pl: Add default --git-fallback, remove default --git
  scripts/get_maintainer.pl: Use .get_maintainer.conf from . then $HOME then scripts

 scripts/get_maintainer.pl |  123 ++++++++++++++++++++++++++++++++++++---------
 1 files changed, 99 insertions(+), 24 deletions(-)

-- 
1.7.3.rc1

