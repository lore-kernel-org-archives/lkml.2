Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2KXA3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:29:15 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:54902 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab2KXA15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:57 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH 20/24] MAINTAINERS: remove include/linux/of_pwm.h
Date: Fri, 23 Nov 2012 22:26:44 -0200
Message-Id: <1353716808-16375-21-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added by commit 200efed (pwm: Take over maintainership of the PWM
subsystem), but I could not find any trace of that file being ever added
to the repository.

Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a3a57a..331b3a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5946,7 +5946,6 @@ T:	git git://gitorious.org/linux-pwm/linux-pwm.git
 F:	Documentation/pwm.txt
 F:	Documentation/devicetree/bindings/pwm/
 F:	include/linux/pwm.h
-F:	include/linux/of_pwm.h
 F:	drivers/pwm/
 F:	drivers/video/backlight/pwm_bl.c
 F:	include/linux/pwm_backlight.h
-- 
1.7.11.7

