Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1GZBYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:24:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab1GZBYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:25 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=vhdKIqpQuCYA:10 a=8fSawYyx68cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=VejAsy1XI8Bi0Be52zkA:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012238.271008621@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 00/19] [GIT PULL] ktest: new features and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following patches.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-ktest.git

    branch: for-linus


Steven Rostedt (19):
      ktest: Notify reason to break out of monitoring boot
      ktest: Add detection of triple faults
      ktest: Add CONFIG_BISECT_GOOD option
      ktest: Add TEST_NAME option
      ktest: Implement our own force min config
      ktest: Have wait on stdio honor bug timeout
      ktest: Have LOG_FILE evaluate options as well
      ktest: Allow initrd processing without modules defined
      ktest: Add POST/PRE_BUILD options
      ktest: Have the testing tmp dir include machine name
      ktest: Fix tar extracting of modules to target
      ktest: Add IGNORE_WARNINGS to ignore warnings in some patches
      ktest: Add helper function to avoid duplicate code
      ktest: Require one TEST_START in config file
      ktest: Add test type make_min_config
      ktest: Use Kconfig dependencies to shorten time to make min_config
      ktest: Add prompt to use OUTPUT_MIN_CONFIG
      ktest: Keep fonud configs separate from default configs
      ktest: Fix bug when ADD_CONFIG is set but MIN_CONFIG is not

----
 tools/testing/ktest/ktest.pl    |  970 +++++++++++++++++++++++++++++++++------
 tools/testing/ktest/sample.conf |  142 ++++++-
 2 files changed, 963 insertions(+), 149 deletions(-)
