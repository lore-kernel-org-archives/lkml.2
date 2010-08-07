Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0HGRh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 13:37:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35289 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0HGRh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 13:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fG/LKyACjcvXgMEvn7x4bWzgZpFpbPXFG1xUEFhfif3oNYa/vz2N/RLw2kUgJkx6jK
         G2FJOysXFUMhg3Fo1LWfh4tucxqLQisCFCiLiuAgNFNm0z+SNorBY62TcAC4/8OppOo4
         ThN8fYv3v1Y0OScV/OIbuDqZOziHJgHuxCQWQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] [CPUFREQ] add missing __percpu markup in pcc-cpufreq.c
Date: Sun,  8 Aug 2010 02:37:23 +0900
Message-Id: <1281202643-26709-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcc_cpu_info is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
index a36de5b..994230d 100644
--- a/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/pcc-cpufreq.c
@@ -110,7 +110,7 @@ struct pcc_cpu {
 	u32 output_offset;
 };
 
-static struct pcc_cpu *pcc_cpu_info;
+static struct pcc_cpu __percpu *pcc_cpu_info;
 
 static int pcc_cpufreq_verify(struct cpufreq_policy *policy)
 {
-- 
1.7.0.4

