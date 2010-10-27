Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890Ab0J0K7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:59:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37457 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab0J0K7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GyC/U5cPmue49QujTduDsDVpaKNa+BknOqmC2PfAh9XbjQngqFzR2Vpxk2hvPltrnd
         2imUbwVXIh/kpzwONH+tZ9X6Mmh/0BdQffn7lBLFTMyzGgC/eV2v/JxSkBIYNvIs6a+v
         HV+mGR48pfli8GXFqmxKGgVsWOAIi1ToScAms=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: John Reiser <jreiser@bitwagon.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 3/3] ftrace/MIPS: Enable C Version of recordmcount
Date: Wed, 27 Oct 2010 18:59:09 +0800
Message-Id: <bb99009a9ac79d3f55a8c8bf1c8bd2bc0e1f160e.1288176026.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1288176026.git.wuzhangjin@gmail.com>
References: <cover.1288176026.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1288176026.git.wuzhangjin@gmail.com>
References: <cover.1288176026.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Selects HAVE_C_RECORDMCOUNT to use the C version of the recordmcount
intead of the old Perl Version of recordmcount.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 46cae2b..144e4b3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -9,6 +9,7 @@ config MIPS
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_C_RECORDMCOUNT
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-- 
1.7.1

