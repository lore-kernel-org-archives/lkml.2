Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab0J2Fo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:44:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0J2FoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:44:25 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=BtpVnGxi90QA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=ehErCBslyiwAo03WdQEA:9 a=-4nCO0Et9s7hiz02pI3hPPi144MA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029054310.790179545@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 01:43:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 0/5] [GIT PULL] kconfig: Fixes to make localmodconfig
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest for-linus tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-kconfig.git
for-linus


Steven Rostedt (3):
      kconfig: Make localmodconfig handle environment variables
      kconfig: Fix streamline_config to read multi line deps in Kconfig files
      kconfig: Have streamline_config process menuconfigs too

hiromu (1):
      kconfig: Fix missing declaration of variable $dir in streamline_config.pl

hiromu yagura (1):
      kconfig: Fix variable name typo %prompts in streamline_config.pl

----
 scripts/kconfig/streamline_config.pl |   43 ++++++++++++++++++++++++++++-----
 1 files changed, 36 insertions(+), 7 deletions(-)
