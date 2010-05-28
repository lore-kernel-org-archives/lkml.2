Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab0E1Orw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:47:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0E1Oru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:47:50 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=KKzDjXtwiLIA:10 a=1CvaPgNKC-EA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=_WFsjLJUG9tjM5AFKroA:9 a=dZBAAtPjV4BIqiwRuVTe7dLg6Y4A:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100528144323.232583082@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 28 May 2010 10:43:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH 0/3] [GIT PULL] kconfig: minor updates to streamline_config.pl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

These are minor updates for the streamline_config.pl script.

Please pull the latest for-linus tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-kconfig.git

    branch: for-linus


Toralf Foerster (3):
      kconfig: Make a variable local in streamline_config.pl
      kconfig: Fix typo in comment in streamline_config.pl
      kconfig: Hide error output in find command in streamline_config.pl

----
 scripts/kconfig/streamline_config.pl |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)
