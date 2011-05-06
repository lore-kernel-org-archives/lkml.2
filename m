Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1EFBEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:04:14 -0400
Received: from kroah.org ([198.145.64.141]:36554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1EFAYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:06 2011
Message-Id: <20110506002206.236863978@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:19:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Rose <gregory.v.rose@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andreas Radke <a.radke@arcor.de>
Subject: [012/143] Remove extra struct page member from the buffer info structure
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Rose <gregory.v.rose@intel.com>

commit b1d670f10e8078485884f0cf7e384d890909aeaa upstream.

declaration.

Reported-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Greg Rose <gregory.v.rose@intel.com>
Tested-by: Emil Tantilov <emil.s.tantilov@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Andreas Radke <a.radke@arcor.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igbvf/igbvf.h |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/igbvf/igbvf.h
+++ b/drivers/net/igbvf/igbvf.h
@@ -125,7 +125,6 @@ struct igbvf_buffer {
 			unsigned int page_offset;
 		};
 	};
-	struct page *page;
 };
 
 union igbvf_desc {


