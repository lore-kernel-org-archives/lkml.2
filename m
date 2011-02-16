Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab1BPAdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:33:46 -0500
Received: from kroah.org ([198.145.64.141]:49734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab1BPAYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:48 2011
Message-Id: <20110216001448.386039250@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ari Kauppi <kauppi@papupata.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [233/272] oprofile: Fix usage of CONFIG_HW_PERF_EVENTS for oprofile_perf_init and friends
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ari Kauppi <kauppi@papupata.org>

commit 1ea1bdf7faa4d0b5293e605f2e1ef1c2c59f6b53 upstream.

The implementations are flagged in Makefile with CONFIG_HW_PERF_EVENTS
instead of CONFIG_PERF_EVENTS.

Signed-off-by: Ari Kauppi <kauppi@papupata.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/oprofile.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -186,10 +186,10 @@ int oprofile_add_data(struct op_entry *e
 int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
-#ifdef CONFIG_PERF_EVENTS
+#ifdef CONFIG_HW_PERF_EVENTS
 int __init oprofile_perf_init(struct oprofile_operations *ops);
 void oprofile_perf_exit(void);
 char *op_name_from_perf_id(void);
-#endif /* CONFIG_PERF_EVENTS */
+#endif /* CONFIG_HW_PERF_EVENTS */
 
 #endif /* OPROFILE_H */


