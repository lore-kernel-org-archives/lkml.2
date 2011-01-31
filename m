Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1AaXCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:02:14 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:38720 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1AaXCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:02:12 -0500
Date: Mon, 31 Jan 2011 16:02:11 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: linux-omap@vger.kernel.org, khilman@deeprootsystems.com, tony@atomide.com,
        b-cousson@ti.com
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] MAINTAINERS: add entry for OMAP powerdomain/clockdomain
 per-SoC layer support
Message-ID: <alpine.DEB.2.00.1101310955300.16671@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-1434103111-1296493040=:16671"
Content-ID: <alpine.DEB.2.00.1101311600310.16671@utopia.booyaka.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-1434103111-1296493040=:16671
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.1101311600311.16671@utopia.booyaka.com>


Add Rajendra Nayak and myself as maintainers for the OMAP
powerdomain/clockdomain per-SoC layer code.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Beno=EEt Cousson <b-cousson@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

---

This patch is being sent for comment only; Tony will probably queue=20
this up with the rest of the OMAP patches in the .39 window.

 MAINTAINERS |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 55592f8..d203d8b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4451,6 +4451,16 @@ L:=09linux-omap@vger.kernel.org
 S:=09Maintained
 F:=09arch/arm/*omap*/*pm*
=20
+OMAP POWERDOMAIN/CLOCKDOMAIN SOC ADAPTATION LAYER SUPPORT
+M:=09Rajendra Nayak <rnayak@ti.com>
+M:=09Paul Walmsley <paul@pwsan.com>
+L:=09linux-omap@vger.kernel.org
+S:=09Maintained
+F:=09arch/arm/mach-omap2/powerdomain2xxx_3xxx.c
+F:=09arch/arm/mach-omap2/powerdomain44xx.c
+F:=09arch/arm/mach-omap2/clockdomain2xxx_3xxx.c
+F:=09arch/arm/mach-omap2/clockdomain44xx.c
+
 OMAP AUDIO SUPPORT
 M:=09Jarkko Nikula <jhnikula@gmail.com>
 L:=09alsa-devel@alsa-project.org (subscribers-only)
--=20
1.7.2.3
--155748971-1434103111-1296493040=:16671--
