Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0IOJzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 05:55:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:44360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0IOJzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 05:55:04 -0400
Message-ID: <4C9097D6.7050103@kernel.org>
Date: Wed, 15 Sep 2010 11:54:30 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
CC: Florian Mickler <florian@mickler.org>
Subject: [GIT PULL] workqueue: add documentation
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 09:54:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please consider pulling from the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

The branch contains one commit to add documentation.

Tejun Heo (1):
      workqueue: add documentation

 Documentation/workqueue.txt |  380 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/workqueue.h   |    4 +
 kernel/workqueue.c          |   27 ++-
 3 files changed, 401 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/workqueue.txt

Thanks.

--
tejun
