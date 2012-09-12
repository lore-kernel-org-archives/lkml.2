Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2ILWpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:45:34 -0400
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:36753 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751055Ab2ILWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:45:33 -0400
Message-ID: <1347489929.9103.3.camel@offbook>
Subject: [PATCH] staging: keucr: remove String func prototypes
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Al Cho <acho@novell.com>
Cc: lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org
Date: Thu, 13 Sep 2012 00:45:29 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1b9f644dfeb638e0146ce54f4e48c87a2841a603 already got rid of
StringCopy and StringCmp, so remove the left over prototypes.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/staging/keucr/smcommon.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/keucr/smcommon.h b/drivers/staging/keucr/smcommon.h
index 278bdb8..4d57203 100644
--- a/drivers/staging/keucr/smcommon.h
+++ b/drivers/staging/keucr/smcommon.h
@@ -25,7 +25,5 @@ Define Difinetion
 #define ERR_NoSmartMedia    0x003A /* Medium Not Present */
 
 /***************************************************************************/
-void StringCopy(char *, char *, int);
-int  StringCmp(char *, char *, int);
 
 #endif
-- 
1.7.9.5



