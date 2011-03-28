Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1C1VmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:42:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55748 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1C1VmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=J8dOsOagYkwELrRbNzhVQhntmUzdogwkfyP191LcQH8n2SBn4ucNeXi2+KR6tA+f8y
         oduUywILG7WwBai9qFl0Uw7VrYd+ebran19C9TQqmna2a2UKEB86G/XjUqSPsszvIVwY
         tTAOalCQfckwUSe6cUGGd6lXhzUPr8WgRuNIM=
MIME-Version: 1.0
Date: Tue, 29 Mar 2011 03:12:23 +0530
Message-ID: <AANLkTi=XCcQZTX-dRoU8QpExD40PY9xf1VokVron-NXm@mail.gmail.com>
Subject: [PATCH] pid: fix typo in function description
From: Sisir Koppaka <sisir.koppaka@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

finds is misspelt as finr. No functional change.

Signed-off-by: Sisir Koppaka <sisir.koppaka@gmail.com>
---
 include/linux/pid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index efceda0..37ea1ba 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -105,7 +105,7 @@ extern struct pid_namespace init_pid_ns;
  * or rcu_read_lock() held.
  *
  * find_pid_ns() finds the pid in the namespace specified
- * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
+ * find_vpid() finds the pid by its virtual id, i.e. in the current namespace
  *
  * see also find_task_by_vpid() set in include/linux/sched.h
  */
-- 
1.7.0.4

                sk
