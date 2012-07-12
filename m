Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161552Ab2GLRtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:49:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161503Ab2GLRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:49:03 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Richard Fontana <fontana2012@gmail.com>
Cc: "Bradley M. Kuhn" <bkuhn@ebb.org>, tytso@mit.edu,
        linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 5/6] copyleft-next: remove section 7 - anti-tivoization
Date: Thu, 12 Jul 2012 10:48:44 -0700
Message-Id: <1342115325-9443-6-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.rc1.22.gf5241
In-Reply-To: <1342115325-9443-1-git-send-email-mcgrof@do-not-panic.com>
References: <1342115325-9443-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

The anti-tivoization clauses must go if we want this license
to be ever considered for usage with the Linux kernel.
This patch removes that entire section.

The re-enumerating of the sections is done separately
to make it easier for review.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 copyleft-next |   56 ++++++--------------------------------------------------
 1 file changed, 6 insertions(+), 50 deletions(-)

diff --git a/copyleft-next b/copyleft-next
index 32f1274..fdb20c2 100644
--- a/copyleft-next
+++ b/copyleft-next
@@ -153,17 +153,15 @@ conditions:
     You modified the Program, and giving a relevant date.
 
     b) The Derivative Work must carry prominent notices stating that
-    it is released under this License and any conditions added under
-    section 7.  This requirement modifies the requirement in section 3
-    to "keep intact all notices".
+    it is released under this License. This requirement modifies the
+    requirement in section 3 to "keep intact all notices".
 
     c) You must license the entire Derivative Work, as a whole, under
     this License to anyone who comes into possession of a copy.  This
-    License will therefore apply, along with any applicable section 7
-    additional terms, to the whole of the Derivative Work, and all its
-    parts, regardless of how they are packaged. However, if We license
-    a Covered Work under Proprietary Terms, this subsection c shall
-    not apply to Your Derivative Work.
+    License will therefore apply to the whole of the Derivative Work,
+    and all its parts, regardless of how they are packaged. However,
+    if We license a Covered Work under Proprietary Terms, this
+    subsection c shall not apply to Your Derivative Work.
 
     d) If the Program's interactive user interfaces display Legal
     Notices, such Legal Notices must be preserved by Your Derivative
@@ -221,48 +219,6 @@ ways:
          noncommercially, and only if You received the Object Code
          with such an offer, in accord with the preceding option.
 
-  7. User Product Lockdown.
-
-  A "User Product" is either (1) a "consumer product", which means any
-tangible personal property which is normally used for personal, family,
-or household purposes, or (2) anything designed or sold for incorporation
-into a dwelling.  In determining whether a product is a consumer product,
-doubtful cases shall be resolved in favor of coverage.  For a particular
-product received by a particular user, "normally used" refers to a
-typical or common use of that class of product, regardless of the status
-of the particular user or of the way in which the particular user
-actually uses, or expects or is expected to use, the product.  A product
-is a consumer product regardless of whether the product has substantial
-commercial, industrial or non-consumer uses, unless such uses represent
-the only significant mode of use of the product.
-
-  "Installation Information" for a User Product means any methods,
-procedures, authorization keys, or other information required to
-install and execute Derivative Works of a Covered Work in that User
-Product from a Derivative Work of its Corresponding Source.  The
-information must suffice to ensure that the continued functioning of
-the Object Code Derivative Work is in no case prevented or interfered
-with solely because modification has been made.
-
-  If You distribute an Object Code work under section 5 in, or with,
-or specifically for use in, a User Product, and the distributing
-occurs as part of a transaction in which the right of possession and
-use of the User Product is transferred to the recipient in perpetuity
-or for a fixed term (regardless of how the transaction is
-characterized), the Corresponding Source distributed under this
-section must be accompanied by the Installation Information.  But this
-requirement does not apply if neither You nor any third party retains
-the ability to install modified Object Code on the User Product (for
-example, the work has been installed in non-field-modifiable ROM).
-
-  The requirement to provide Installation Information does not include a
-requirement to continue to provide support service, warranty, or updates
-for a work that has been modified or installed by the recipient, or for
-the User Product in which it has been modified or installed.  Access to a
-network may be denied when the modification itself materially and
-adversely affects the operation of the network or violates the rules and
-protocols for communication across the network.
-
   8. Additional Terms.
 
   Notwithstanding any other provision of this License, for material
-- 
1.7.10.rc1.22.gf5241

