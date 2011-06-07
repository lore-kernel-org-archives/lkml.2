Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1FGMGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:06:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50866 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab1FGMGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=PV6sWkHO++0vr9YZZgq6S0RXgYvjHbANTUf/nnU2XZRllStI7qa4GjcVQalKmedwzk
         LcxrP+ZVQgQv49PP4n8qYqoOIixGTmRS8ceJJMkyDXHx6CwndLhN1BU8Zn+dNEkjcWJj
         iq46qXwLo6NLvRGFy5GDeix+qSW+XsuYF5z8c=
Date: Tue, 7 Jun 2011 20:06:30 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>
Subject: [Patch] doc: remove ns_cgroup from feature-removal-schedule.txt
Message-ID: <20110607120630.GA3550@cr0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following commit Daniel removed ns_cgroup

	commit a77aea92010acf54ad785047234418d5d68772e2
	Author: Daniel Lezcano <daniel.lezcano@free.fr>
	Date:   Thu May 26 16:25:23 2011 -0700

	    cgroup: remove the ns_cgroup

but Daniel forgot to remove the related doc in feature-removal-schedule.txt.
This patch removes that too.

Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 1a9446b..72e2384 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -481,23 +481,6 @@ Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 
 ----------------------------
 
-What:   namespace cgroup (ns_cgroup)
-When:   2.6.38
-Why:    The ns_cgroup leads to some problems:
-	* cgroup creation is out-of-control
-	* cgroup name can conflict when pids are looping
-	* it is not possible to have a single process handling
-	a lot of namespaces without falling in a exponential creation time
-	* we may want to create a namespace without creating a cgroup
-
-	The ns_cgroup is replaced by a compatibility flag 'clone_children',
-	where a newly created cgroup will copy the parent cgroup values.
-	The userspace has to manually create a cgroup and add a task to
-	the 'tasks' file.
-Who:    Daniel Lezcano <daniel.lezcano@free.fr>
-
-----------------------------
-
 What:	iwlwifi disable_hw_scan module parameters
 When:	2.6.40
 Why:	Hareware scan is the prefer method for iwlwifi devices for
