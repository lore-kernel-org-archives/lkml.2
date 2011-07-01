Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab1GAXbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 19:31:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57845 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab1GAXbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 19:31:32 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [RFC 1/4] kbuild: export MAKECMDGOALS
Date: Fri,  1 Jul 2011 19:31:13 -0400
Message-Id: <1309563076-5050-2-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Steven Rostedt <srostedt@redhat.com>
---
 Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index afb8e0d..ea517fd 100644
--- a/Makefile
+++ b/Makefile
@@ -22,6 +22,9 @@ LC_COLLATE=C
 LC_NUMERIC=C
 export LC_COLLATE LC_NUMERIC
 
+# Export make goals
+export MAKECMDGOALS
+
 # We are using a recursive build, so we need to do a little thinking
 # to get the ordering right.
 #
-- 
1.7.3.4.574.g608b.dirty

