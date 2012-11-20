Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2KTMh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:37:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab2KTMh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:37:26 -0500
Date: Tue, 20 Nov 2012 14:37:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: mtosatti@redhat.com, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: taking co-maintenance
Message-ID: <20121120123724.GI21208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating MAINTAINERS file.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 6b5b0b7..b273360 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4281,6 +4281,7 @@ F:	include/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Marcelo Tosatti <mtosatti@redhat.com>
+M:	Gleb Natapov <gleb@redhat.com>
 L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Supported
--
			Gleb.
