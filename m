Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1IEOti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:49:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64954 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab1IEOtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:49:36 -0400
Message-ID: <4E64E172.7000506@gmail.com>
Date: Mon, 05 Sep 2011 22:49:22 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] switching-sched.txt: remove 'as' for as is no longer supported
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.1-rc3.

as is no longer supported and we can not use 'elevator=as' any
more.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 Documentation/block/switching-sched.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/block/switching-sched.txt b/Documentation/block/switching-sched.txt
index 71cfbdc..3b2612e 100644
--- a/Documentation/block/switching-sched.txt
+++ b/Documentation/block/switching-sched.txt
@@ -1,6 +1,6 @@
 To choose IO schedulers at boot time, use the argument 'elevator=deadline'.
-'noop', 'as' and 'cfq' (the default) are also available. IO schedulers are
-assigned globally at boot time only presently.
+'noop' and 'cfq' (the default) are also available. IO schedulers are assigned
+globally at boot time only presently.
 
 Each io queue has a set of io scheduler tunables associated with it. These
 tunables control how the io scheduler works. You can find these entries
-- 
1.7.1

