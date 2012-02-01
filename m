Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab2BAVIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:08:32 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37494 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757089Ab2BAVI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:08:26 -0500
X-Sasl-enc: S7EK3oHLZAdyh9i8iDMhf+aG5G9C6PTdJkolFgPXiALV 1328130505
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:39 2012
Message-Id: <20120201205739.498219105@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [23/65] mach-ux500: enable ARM errata 764369
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>

commit d65015f7c5c5be9fd3f5e567889c844ba81bdc9c upstream.

This applies ARM errata 764369 for all ux500 platforms.

Signed-off-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-ux500/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -7,6 +7,7 @@ config UX500_SOC_COMMON
 	select HAS_MTU
 	select ARM_ERRATA_753970
 	select ARM_ERRATA_754322
+	select ARM_ERRATA_764369
 
 menu "Ux500 SoC"
 


