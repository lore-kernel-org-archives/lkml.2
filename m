Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0GUEvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 00:51:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58207 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab0GUEvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eQOzl4SG6v4x2ATicF8WY16gjdIcXDLWr0w/BhSuUCpUW7FDtKUtn2nH9MpoQpfoky
         Kh0+N+vQZkwvxn5uz7epbcsciQCXdbOIU+3JPrmIFk9B8RgCvxjakjXItPj3XRhlw2cM
         l2+CcQL3TlEGeEwvVz53OVJn20IhQX9c8FnGQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 5/5]Documentation/arm/IXP2000 update web address.
Date: Tue, 20 Jul 2010 21:50:51 -0700
Message-Id: <1279687861-29282-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
References: <1279687861-29282-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address to the company
web site due to me being unable to locate the info.
if anybody knows where this might be, let me know and
I'll resend this patch.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/arm/IXP2000 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/arm/IXP2000 b/Documentation/arm/IXP2000
index e0148b6..68d21d9 100644
--- a/Documentation/arm/IXP2000
+++ b/Documentation/arm/IXP2000
@@ -14,7 +14,7 @@ telecom systems. In addition to an XScale core, it contains up to 8
 interfaces (UTOPIA, SPI, etc), a PCI host bridge, one serial port,
 flash interface, and some other odds and ends. For more information, see:
 
-http://developer.intel.com/design/network/products/npfamily/ixp2xxx.htm
+http://developer.intel.com
 
 2. Linux Support
 
-- 
1.7.1.rc1.21.gf3bd6

