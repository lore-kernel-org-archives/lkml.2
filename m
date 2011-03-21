Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1CUXpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:45:51 -0400
Received: from kroah.org ([198.145.64.141]:49462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1CUXPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:13 2011
Message-Id: <20110321230713.733123999@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Mahoney <jeffm@suse.com>
Subject: [44/87] staging: winbond: needs <linux/delay.h> for msleep and friends
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit cecf826df8648c843ea8db63b1f82c154a74db36 upstream.

linux/delay.h is pulled in somehow on x86 but not on ia64 or powerpc.

This fixes a build failure on those arches since they use [mu]delay.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/winbond/core.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -3,6 +3,7 @@
 
 #include <linux/wireless.h>
 #include <linux/types.h>
+#include <linux/delay.h>
 
 #include "wbhal_s.h"
 #include "mto.h"


