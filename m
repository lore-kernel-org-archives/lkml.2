Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab0FBJqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:46:54 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:19844 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab0FBJqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LpdhINpf8qn95P3Mprofj6Xi3egZl5O7Q7aJguqAeK1n4bauN5oIeBLL3tWNiOqJpV
         aGjtrV7wiSgjVeGdvXb+XMx2Yvj985uuA1PImL1YL389xytkYc+PnHnwoEfai/k5TTpq
         xg/9uRSaRnfq8OWEsROudUq7QxlMep+YNuzwU=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 5/5] Document unknown_nmi_dump_log variable
Date: Wed,  2 Jun 2010 09:39:19 +0200
Message-Id: <1275464359-1566-6-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention unknown_nmi_dump_log in sysctl documentation.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 Documentation/sysctl/kernel.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 3894eaa..b554838 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -65,6 +65,7 @@ show up in /proc/sys/kernel:
 - tainted
 - threads-max
 - unknown_nmi_panic
+- unknown_nmi_dump_log
 - version
 
 ==============================================================
@@ -515,6 +516,15 @@ If a system hangs up, try pressing the NMI switch.
 
 ==============================================================
 
+unknown_nmi_dump_log:
+
+The value in this file affects behavior of handling NMI. When dump
+capture kernel is loaded, the value is non-zero and unknown NMI is
+trapped, then vmcore's log buffer and CPU registers are extracted and
+displayed on console.
+
+==============================================================
+
 panic_on_unrecovered_nmi:
 
 The default Linux behaviour on an NMI of either memory or unknown is to continue
-- 
1.7.1

