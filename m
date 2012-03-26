Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2CZCHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 22:07:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50105 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2CZCH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 22:07:29 -0400
From: Calvin Owens <jcalvinowens@gmail.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: jcalvinowens@gmail.com
Subject: [PATCH] Remove form-feed (0x0c) characters in COPYING
Date: Sun, 25 Mar 2012 21:06:29 -0500
Message-Id: <1332727589-3934-1-git-send-email-jcalvinowens@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The COPYING file contains five \x0c ASCII form-feed characters. This
patch removes them.

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 COPYING |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/COPYING b/COPYING
index ca442d3..0dde99b 100644
--- a/COPYING
+++ b/COPYING
@@ -71,7 +71,7 @@ patent must be licensed for everyone's free use or not licensed at all.
 
   The precise terms and conditions for copying, distribution and
 modification follow.
-
+
 		    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
@@ -126,7 +126,7 @@ above, provided that you also meet all of these conditions:
     License.  (Exception: if the Program itself is interactive but
     does not normally print such an announcement, your work based on
     the Program is not required to print an announcement.)
-
+
 These requirements apply to the modified work as a whole.  If
 identifiable sections of that work are not derived from the Program,
 and can be reasonably considered independent and separate works in
@@ -184,7 +184,7 @@ access to copy from a designated place, then offering equivalent
 access to copy the source code from the same place counts as
 distribution of the source code, even though third parties are not
 compelled to copy the source along with the object code.
-
+
   4. You may not copy, modify, sublicense, or distribute the Program
 except as expressly provided under this License.  Any attempt
 otherwise to copy, modify, sublicense or distribute the Program is
@@ -241,7 +241,7 @@ impose that choice.
 
 This section is intended to make thoroughly clear what is believed to
 be a consequence of the rest of this License.
-
+
   8. If the distribution and/or use of the Program is restricted in
 certain countries either by patents or by copyrighted interfaces, the
 original copyright holder who places the Program under this License
@@ -294,7 +294,7 @@ PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.
 
 		     END OF TERMS AND CONDITIONS
-
+
 	    How to Apply These Terms to Your New Programs
 
   If you develop a new program, and you want it to be of the greatest
-- 
1.7.3.4

