Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1FBTO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:14:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1FBTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:14:55 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=TQt_f7FfLAkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=p7bM00qMOSH_5Za40eQA:9 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110602191334.417940259@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Jun 2011 15:13:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL] ktest: fixes for config_bisect
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

As I've been doing a bit of config_bisects with ktest lately, I've
discovered a few minor bugs that can cause it to give the wrong result.

Two of the patches fix the config_bisect, and one fixes the error
path, if for some reason your reboot fails to reboot the remote box.

Note, I've notice problems with git.kernel.org mirroring, and
a fetch can result in the old version of the branch or the new version.
The top commit should be:

  commit 9bf7174949aef2f43253956e1f3ab01698abbd79
  Author: Steven Rostedt <srostedt@redhat.com>
  Date:   Wed Jun 1 23:27:19 2011 -0400
  ktest: Ignore unset values of the minconfig in config_bisect


Please pull the following patches from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-ktest.git

    branch: for-linus


Steven Rostedt (3):
      ktest: Fix off-by-one in config bisect result
      ktest: Fix result of rebooting the kernel
      ktest: Ignore unset values of the minconfig in config_bisect

----
 tools/testing/ktest/ktest.pl |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)
