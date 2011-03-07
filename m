Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1CGTyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:54:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62903 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab1CGTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Tcaynde+GgBPMDHkNPknP95CfMegI33roMiNr/pf2O7qyhghyARVQ4E691ZIqCR2AL
         T6g2m/gY9UfLWrUulOOKGLkNvqtSVtVycMg0PYogMNUlS4Rbq6n5fvtkol7w2yMSG/Z0
         fHvBMG/NNQCgnz069QpXgUa7R+DdOdA/ZMqtg=
MIME-Version: 1.0
Date: Mon, 7 Mar 2011 20:54:09 +0100
Message-ID: <AANLkTim5w1wRPk=+GgVEm-k9fMBWGt513v9txyXF+kmJ@mail.gmail.com>
Subject: [PATCH] Documentation/CodingStyle: fixed header file for pr_info()
 and pr_debug(). Removed unnecessary "Last updated" line
From: Roland Kammerer <dev.rck@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_info() and pr_debug() are in linux/printk.h
Last updated is unnecessary, we have git for that

Signed-off-by: Roland Kammerer <dev.rck@gmail.com>
---
 Documentation/CodingStyle |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 8bb3723..1cd3478 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -659,7 +659,7 @@ There are a number of driver model diagnostic
macros in <linux/device.h>
 which you should use to make sure messages are matched to the right device
 and driver, and are tagged with the right level:  dev_err(), dev_warn(),
 dev_info(), and so forth.  For messages that aren't associated with a
-particular device, <linux/kernel.h> defines pr_debug() and pr_info().
+particular device, <linux/printk.h> defines pr_debug() and pr_info().

 Coming up with good debugging messages can be quite a challenge; and once
 you have them, they can be a huge help for remote troubleshooting.  Such
@@ -819,6 +819,3 @@ language C, URL: http://www.open-std.org/JTC1/SC22/WG14/
 Kernel CodingStyle, by greg@kroah.com at OLS 2002:
 http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/

---
-Last updated on 2007-July-13.
-
-- 
1.7.4.1
