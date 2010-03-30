Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab0C3Rd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:33:58 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:18040 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab0C3Rd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:33:56 -0400
Message-ID: <4BB2358B.3090800@oracle.com>
Date: Tue, 30 Mar 2010 10:31:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: [PATCH -next] module.h: add stub for is_module_percpu_address
References: <20100330191834.f2009292.sfr@canb.auug.org.au>
In-Reply-To: <20100330191834.f2009292.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BB235CC.0122:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build for CONFIG_MODULES not enabled by providing a stub
for is_module_percpu_address().

kernel/lockdep.c:605: error: implicit declaration of function 'is_module_percpu_address'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/module.h |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20100330.orig/include/linux/module.h
+++ linux-next-20100330/include/linux/module.h
@@ -567,6 +567,11 @@ static inline bool is_module_address(uns
 	return false;
 }
 
+static inline bool is_module_percpu_address(unsigned long addr)
+{
+	return false;
+}
+
 static inline bool is_module_text_address(unsigned long addr)
 {
 	return false;
