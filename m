Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab1KRXLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:11:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52925 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab1KRXLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:11:04 -0500
Date: Fri, 18 Nov 2011 15:10:38 -0800
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Message-ID: <tip-3890c136357284cb0656f9dd0e62286995ad32e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4EAA5E54.1080102@cn.fujitsu.com>
References: <4EAA5E54.1080102@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: update Documentation on max preds limit
Git-Commit-ID: 3890c136357284cb0656f9dd0e62286995ad32e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:10:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3890c136357284cb0656f9dd0e62286995ad32e9
Gitweb:     http://git.kernel.org/tip/3890c136357284cb0656f9dd0e62286995ad32e9
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 28 Oct 2011 15:48:36 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 4 Nov 2011 21:25:57 -0400

tracing: update Documentation on max preds limit

Preds is no longer stored in a fixed-size stack. The max preds now
is 2^14, and is way more than enough, so don't bother to document it.

Link: http://lkml.kernel.org/r/4EAA5E54.1080102@cn.fujitsu.com

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
 
