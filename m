Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2HBGCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:02:09 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:35263 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab2HBGCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:02:06 -0400
Subject: [PATCH][TRIVIAL] fix some typos in kernel/trace
From: Wang Tianhong <wangthbj@linux.vnet.ibm.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Aug 2012 14:02:00 +0800
Message-ID: <1343887320.2228.9.camel@louis-ThinkPad-T410>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 12080206-2000-0000-0000-000008925DA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some typos in kernel/trace.

Signed-off-by: Wang Tianhong <wangthbj@linux.vnet.ibm.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 49491fa..b32ed0e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2816,7 +2816,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_enable);
  * to the buffer after this will fail and return NULL.
  *
  * This is different than ring_buffer_record_disable() as
- * it works like an on/off switch, where as the disable() verison
+ * it works like an on/off switch, where as the disable() version
  * must be paired with a enable().
  */
 void ring_buffer_record_off(struct ring_buffer *buffer)
@@ -2839,7 +2839,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_off);
  * ring_buffer_record_off().
  *
  * This is different than ring_buffer_record_enable() as
- * it works like an on/off switch, where as the enable() verison
+ * it works like an on/off switch, where as the enable() version
  * must be paired with a disable().
  */
 void ring_buffer_record_on(struct ring_buffer *buffer)
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5c38c81..08acf42 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -426,15 +426,15 @@ __setup("trace_buf_size=", set_buf_size);

 static int __init set_tracing_thresh(char *str)
 {
-       unsigned long threshhold;
+       unsigned long threshold;
        int ret;

        if (!str)
                return 0;
-       ret = strict_strtoul(str, 0, &threshhold);
+       ret = strict_strtoul(str, 0, &threshold);
        if (ret < 0)
                return 0;
-       tracing_thresh = threshhold * 1000;
+       tracing_thresh = threshold * 1000;
        return 1;
 }
 __setup("tracing_thresh=", set_tracing_thresh);


