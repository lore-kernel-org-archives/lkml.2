Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1J1HrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:47:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50950 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab1J1HrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:47:03 -0400
Message-ID: <4EAA5E54.1080102@cn.fujitsu.com>
Date: Fri, 28 Oct 2011 15:48:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: update Documentation on max preds limit
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 15:45:01,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 15:45:01,
	Serialize complete at 2011-10-28 15:45:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preds is no longer stored in a fixed-size stack. The max preds now
is 2^14, and is way more than enough, so don't bother to document it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/trace/events.txt |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index b510564..bb24c2a 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -191,8 +191,6 @@ And for string fields they are:
 
 Currently, only exact string matches are supported.
 
-Currently, the maximum number of predicates in a filter is 16.
-
 5.2 Setting filters
 -------------------
 
-- 
1.7.3.1
