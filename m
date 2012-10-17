Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2JQGde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:33:34 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49875 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2JQGdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <1350455212.3072.27.camel@joe-AO722>
References: <3b38cb8ab136e5af3a70fceb7d77ad9fc889eb3f.1350451100.git.viresh.kumar@linaro.org>
	<1350452374.3072.19.camel@joe-AO722>
	<CAKohpo=LL+wPcb97KNQvHbX0fzhnRBZjPsHXTj1PdYObuVVTgw@mail.gmail.com>
	<1350453876.3072.23.camel@joe-AO722>
	<CAKohpom6xHUmu2uYijdNVJHj6sFwJhYUYvXy+dN1a+WqzqTjZA@mail.gmail.com>
	<1350455212.3072.27.camel@joe-AO722>
Date: Wed, 17 Oct 2012 12:03:31 +0530
Message-ID: <CAKohpo=fgz98F+1SBG9TgO0EsPd_XLznJ0Z__0ehsgm14EZK7A@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Improve debug prints
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, pdsw-power-team@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2012 11:56, Joe Perches <joe@perches.com> wrote:
> Oh good, but please use a space between KBUILD_MODNAME
> and the quoted ": ".

Anything technical behind it or just for code formatting? As output is
same in both cases :)

------------------------8<----------------------8<-------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Wed, 17 Oct 2012 10:38:31 +0530
Subject: [PATCH] cpufreq: Improve debug prints

With debug options on, it is difficult to locate cpufreq core's debug prints.
Fix this by prefixing debug prints with KBUILD_MODNAME.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c             | 2 ++
 drivers/cpufreq/cpufreq_performance.c | 2 ++
 drivers/cpufreq/cpufreq_powersave.c   | 2 ++
 drivers/cpufreq/cpufreq_userspace.c   | 2 ++
 drivers/cpufreq/freq_table.c          | 2 ++
 5 files changed, 10 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index db6e337..85df538 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -15,6 +15,8 @@
  *
  */

+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/cpufreq/cpufreq_performance.c
b/drivers/cpufreq/cpufreq_performance.c
index f13a8a9..ceee068 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -10,6 +10,8 @@
  *
  */

+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/cpufreq.h>
diff --git a/drivers/cpufreq/cpufreq_powersave.c
b/drivers/cpufreq/cpufreq_powersave.c
index 4c2eb51..2d948a1 100644
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -10,6 +10,8 @@
  *
  */

+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/cpufreq.h>
diff --git a/drivers/cpufreq/cpufreq_userspace.c
b/drivers/cpufreq/cpufreq_userspace.c
index bedac1a..c8c3d29 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -11,6 +11,8 @@
  *
  */

+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/smp.h>
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 90431cb..49cda25 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -9,6 +9,8 @@
  *
  */

+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
