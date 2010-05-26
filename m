Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0EZSu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:50:57 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:36520 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab0EZSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:50:56 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net D861B35A379
Subject: [PATCH 1/3] HID: Removed obsolete comment from roccat kone driver
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 20:50:50 +0200
Message-ID: <1274899850.9492.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed comment that is obsolete since roccat char device is
implemented

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 17f2dc0..3e5b553 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -22,11 +22,6 @@
  *      Is it possible to remove and reinstall the urb in raw-event- or any
  *      other handler, or to defer this action to be executed somewhere else?
  *
- * TODO implement notification mechanism for overlong macro execution
- *      If user wants to execute an overlong macro only the names of macroset
- *      and macro are given. Should userland tap hidraw or is there an
- *      additional streaming mechanism?
- *
  * TODO is it possible to overwrite group for sysfs attributes via udev?
  */
 
-- 
1.6.6.1



