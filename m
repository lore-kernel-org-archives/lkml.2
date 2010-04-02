Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab0DBTHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:07:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52687 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab0DBTH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:07:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM / freezer fixes for 2.6.34
Date: Fri, 2 Apr 2010 21:10:25 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Ladaan <orenl@cs.columbia.edu>,
       Xiaotian Feng <dfeng@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       David Rientjes <rientjes@google.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004022110.25658.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two freezer fixes for 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

The first one fixes the problem that processes frozen by the cgroup freezer
are thawed during resume, although they shouldn't, and the second one makes
the freezer avoid showing the state of the tasks that didn't refuse to freeze.


 include/linux/freezer.h |    7 +++++--
 kernel/cgroup_freezer.c |    9 ++++++---
 kernel/power/process.c  |    5 ++---
 3 files changed, 13 insertions(+), 8 deletions(-)

---------------

Matt Helsley (1):
      Freezer: Fix buggy resume test for tasks frozen with cgroup freezer

Xiaotian Feng (1):
      Freezer: Only show the state of tasks refusing to freeze

