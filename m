Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1EWNxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:53:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1EWNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:15 -0400
X-Authority-Analysis: v=1.1 cv=NmbQexcdgr4rtO3OwYGrP5Q3rTMpacrTPhuaXkv4uP8= c=1 sm=0 a=vhdKIqpQuCYA:10 a=FItVoo-xZpcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=HGfM4eMJg_wTZz3JjfoA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110523135120.309567301@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 May 2011 09:51:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] ktest: Updates for ktest.pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following patches from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-ktest.git

    branch: for-linus


Steven Rostedt (6):
      ktest: Fix post install command
      ktest: If test failed due to timeout, print that
      ktest: Reboot to good kernel after every bisect run
      ktest: Reboot after each patchcheck run
      ktest: Create variables for the ktest config files
      ktest: Allow options to be used by other options

----
 tools/testing/ktest/ktest.pl    |  156 +++++++++++++++++++++++++++++++++++++--
 tools/testing/ktest/sample.conf |   93 +++++++++++++++++++++++
 2 files changed, 242 insertions(+), 7 deletions(-)
