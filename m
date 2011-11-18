Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1KRLzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:55:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab1KRLzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:55:36 -0500
From: Petr Holasek <pholasek@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Anton Arapov <anton@redhat.com>, Petr Holasek <pholasek@redhat.com>
Subject: [PATCH 2/2] NUMA emulation x86_64: Documentation changes in boot-options.txt
Date: Fri, 18 Nov 2011 12:55:08 +0100
Message-Id: <1321617308-4998-2-git-send-email-pholasek@redhat.com>
In-Reply-To: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
References: <1321617308-4998-1-git-send-email-pholasek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Petr Holasek <pholasek@redhat.com>
---
 Documentation/x86/x86_64/boot-options.txt |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index c54b4f5..33c0c10 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -166,13 +166,15 @@ NUMA
 
   numa=noacpi   Don't parse the SRAT table for NUMA setup
 
-  numa=fake=<size>[MG]
+  numa=fake=<size>[MG][,distance]
 		If given as a memory unit, fills all system RAM with nodes of
 		size interleaved over physical nodes.
+		Optional distance sets linear distance between emulated nodes.
 
-  numa=fake=<N>
+  numa=fake=<N>[,distance]
 		If given as an integer, fills all system RAM with N fake nodes
 		interleaved over physical nodes.
+		Optional distance sets linear distance between emulated nodes.
 
 ACPI
 
-- 
1.7.6.4

