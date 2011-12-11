Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab1LKOuj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 09:50:39 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:11832 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1LKOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 09:50:35 -0500
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: jbottomley@parallels.com, cgroups@vger.kernel.org, bsingharora@gmail.com,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, tj@kernel.org
Subject: [PATCH 0/3] Simple cleanups for cgroups
Date: Sun, 11 Dec 2011 15:45:34 +0100
Message-Id: <1323614738-7405-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While hacking on other stuff I found these spots that could
receive some simple cleanup in cgroup.c. Nothing revolutionary.
Patch 1 is rather trivial, the other 2 are more of a matter of
taste I'd say, but I believe we'd be better of this way.

Glauber Costa (3):
  nitpick: make simple functions inline
  make clone_children a flag
  make 'none' field a flag

 kernel/cgroup.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

-- 
1.7.6.4

