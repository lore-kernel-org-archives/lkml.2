Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1IQBtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 21:49:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58188 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab1IQBti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 21:49:38 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, gthelen@google.com,
        tartler@cs.fau.de, Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH 0/2] Config fragment tools
Date: Fri, 16 Sep 2011 18:49:17 -0700
Message-Id: <1316224159-3556-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11091701-6078-0000-0000-000000DDBAE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last week at Plumbers, Darren Hart and I hosted a BOF on config fragments.
I wanted to say thanks to all the hungry attendees (8pm on the evening where
dinner was fend-for-yourself made it especially hard to draw a crowd) for
their thoughts and discussion. 

There I promised to send out some patches to try to get some common tooling
pushed upstream. I realize this isn't difficult code, but after seeing
almost every distro and build system re-implement the same basic
functionality over and over, it seems like there should be some tooling for
this common use case.

I'm sure this tooling won't work for everyone, and I expect it will need to
evolve to adapt for various use cases, but I wanted to push it out so that I
could make concrete what I was describing in the talk, as well as get some
wider feedback.

So let me know if you have any comments or thoughts!

thanks
-john


CC: gthelen@google.com
CC: tartler@cs.fau.de
CC: Dmitry Fink <Dmitry.Fink@palm.com>
CC: Darren Hart <dvhart@linux.intel.com>
CC: Eric B Munson <ebmunson@us.ibm.com>
CC: Bruce Ashfield <Bruce.Ashfield@windriver.com>
CC: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org

John Stultz (2):
  kconfig: Add make olddefconfig
  kconfig: Add merge_config.sh script

 scripts/kconfig/Makefile        |    2 +-
 scripts/kconfig/conf.c          |    4 ++
 scripts/kconfig/merge_config.sh |   72 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 1 deletions(-)
 create mode 100755 scripts/kconfig/merge_config.sh

-- 
1.7.3.2.146.gca209

