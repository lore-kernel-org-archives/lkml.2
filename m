Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1LMAmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:42:38 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:35093 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1LMAmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:42:36 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Kees Cook <keescook@chromium.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 3/6] docs: Additional LWN links to RCU API
Date: Mon, 12 Dec 2011 16:42:21 -0800
Message-Id: <1323736944-32575-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111213004144.GA32120@linux.vnet.ibm.com>
 <1323736944-32575-1-git-send-email-paulmck@linux.vnet.ibm.com>
x-cbid: 11121300-7408-0000-0000-00000138C46F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Tyler Hicks pointed me at an additional article on RCU and I figured
it should probably be mentioned with the others.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/whatisRCU.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 8e8cdc2..6bbe8dc 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -4,6 +4,7 @@ to start learning about RCU:
 1.	What is RCU, Fundamentally?  http://lwn.net/Articles/262464/
 2.	What is RCU? Part 2: Usage   http://lwn.net/Articles/263130/
 3.	RCU part 3: the RCU API      http://lwn.net/Articles/264090/
+4.	The RCU API, 2010 Edition    http://lwn.net/Articles/418853/
 
 
 What is RCU?
-- 
1.7.8

