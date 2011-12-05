Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1LELik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:38:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55269 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1LELij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:38:39 -0500
Date: Mon, 5 Dec 2011 15:35:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: akpm@linux-foundation.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: remove superfluous debug output
Message-ID: <20111205113545.GA5831@albatros>
References: <201111220034.pAM0YHCC015781@wpaz9.hot.corp.google.com>
 <20111125152601.GA2783@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125152601.GA2783@p183.telecom.by>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/root.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 73af7b2..ce07707 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -53,8 +53,6 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	pr_debug("proc: options = %s\n", options);
-
 	if (!options)
 		return 1;
 
-- 
1.7.0.4

