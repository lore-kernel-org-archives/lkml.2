Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab1BPAoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:44:00 -0500
Received: from kroah.org ([198.145.64.141]:49347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab1BPAXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:43 2011
Message-Id: <20110216001443.002592295@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>, Daniel Drake <dsd@laptop.org>,
        Andres Salomon <dilinger@queued.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [179/272] x86, olpc: Add missing Kconfig dependencies
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: H. Peter Anvin <hpa@linux.intel.com>

commit 76d1f7bfcd5872056902c5a88b5fcd5d4d00a7a9 upstream.

OLPC uses select for OLPC_OPENFIRMWARE, which means OLPC has to
enforce the dependencies for OLPC_OPENFIRMWARE.  Make sure it does so.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
LKML-Reference: <20100923162846.D8D409D401B@zog.reactivated.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2035,6 +2035,7 @@ config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
 	select OLPC_OPENFIRMWARE
+	depends on !X86_64 && !X86_PAE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.


