Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2KGBEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:04:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:54085 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2KGBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:04:49 -0500
Message-ID: <5099B3A8.3010604@infradead.org>
Date: Tue, 06 Nov 2012 17:04:40 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        eric paris <eparis@redhat.com>
CC: linux-audit@redhat.com
Subject: [PATCH] audit: fix auditfilter kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warning in auditfilter.c:

Warning(kernel/auditfilter.c:1157): Excess function parameter 'uid' description in 'audit_receive_filter'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Al Viro <viro@zeniv.linux.org.uk>
Cc:	Eric Paris <eparis@redhat.com>
Cc:	linux-audit@redhat.com (subscribers-only)
---
 kernel/auditfilter.c |    1 -
 1 file changed, 1 deletion(-)

--- lnx-37-rc4.orig/kernel/auditfilter.c
+++ lnx-37-rc4/kernel/auditfilter.c
@@ -1144,7 +1144,6 @@ static void audit_log_rule_change(kuid_t
  * audit_receive_filter - apply all rules to the specified message type
  * @type: audit message type
  * @pid: target pid for netlink audit messages
- * @uid: target uid for netlink audit messages
  * @seq: netlink audit message sequence (serial) number
  * @data: payload data
  * @datasz: size of payload data
