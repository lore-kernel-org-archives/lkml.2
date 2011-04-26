Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab1DZVTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:19:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:22884 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab1DZVPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738832022"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: gregory.v.rose@intel.com, ak@linux.intel.com, emil.s.tantilov@intel.com,
        jeffrey.t.kirsher@intel.com, a.radke@arcor.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [94/106] Remove extra struct page member from the buffer info structure
Message-Id: <20110426211416.91F6F3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Greg Rose <gregory.v.rose@intel.com>

commit b1d670f10e8078485884f0cf7e384d890909aeaa upstream.

declaration.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Greg Rose <gregory.v.rose@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Emil Tantilov <emil.s.tantilov@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Andreas Radke <a.radke@arcor.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igbvf/igbvf.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/igbvf/igbvf.h
===================================================================
--- linux-2.6.35.y.orig/drivers/net/igbvf/igbvf.h
+++ linux-2.6.35.y/drivers/net/igbvf/igbvf.h
@@ -126,7 +126,6 @@ struct igbvf_buffer {
 			unsigned int page_offset;
 		};
 	};
-	struct page *page;
 };
 
 union igbvf_desc {
