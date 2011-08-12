Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab1HLNcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:32:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1HLNcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:21 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [KTEST PATCH 00/10] collection of ktest patches
Date: Fri, 12 Aug 2011 15:32:02 +0200
Message-Id: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More than once I've had to drive git-bisect to bisect boot issues for
Xen guests. The last time I needed to do so I decided to give ktest a
whirl. While whirling I wrote a couple patches and added a few features.
This patchset is the collection.

Andrew Jones (10):
  ktest: create outputdir, if it doesn't exist
  ktest: small cleanup
  ktest: factor reboot code
  ktest: Introduce RESET_TIME
  ktest: refactor monitor/boot/test code
  ktest: make start_monitor_and_boot true to its name
  ktest: Introduce PASS_COUNT
  ktest: test faster, put REBOOT_ON_SUCCESS to more work
  ktest: test faster, favor rsync over the tarball method
  ktest: Introduce FAILURE_LINE

 tools/testing/ktest/ktest.pl    |  208 +++++++++++++++++++++++----------------
 tools/testing/ktest/sample.conf |   23 ++++-
 2 files changed, 147 insertions(+), 84 deletions(-)

-- 
1.7.4.1

