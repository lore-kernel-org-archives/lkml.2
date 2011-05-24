Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1EXHqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:46:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46564 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1EXHqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sE+D2zu2ljNZK9JilboCR4QPkl4Es0yWF5UtfFJJarlpJdqPa2d0+Jss/DfQApWKUW
         yLoId7xsm8CF5sW5jKivYfteIjeK1H4ypaMR76C9laRF8g8ROKGAwhZmA/aubPH0aa3T
         oRJH4U4lU655yQMeU4o4lTAU5AzWmwqN4hn5k=
Subject: Re: [PATCH -next] mtd: fix physmap.h warnings
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Russell King <rmk@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20110524074020.GA9490@flint.arm.linux.org.uk>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	 <20110523113709.4357b4ba.randy.dunlap@oracle.com>
	 <1306216431.2785.46.camel@localhost> <1306216683.2785.47.camel@localhost>
	 <20110524074020.GA9490@flint.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 10:42:23 +0300
Message-ID: <1306222943.2785.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] mtd: fix physmap.h warnings

Fix build warnings in physmap.h:

include/linux/mtd/physmap.h:25: warning: 'struct platform_device' declared inside parameter list
include/linux/mtd/physmap.h:25: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/mtd/physmap.h:26: warning: 'struct platform_device' declared inside parameter list
include/linux/mtd/physmap.h:27: warning: 'struct platform_device' declared inside parameter list

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/mtd/physmap.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mtd/physmap.h b/include/linux/mtd/physmap.h
index 49b9590..697cc98 100644
--- a/include/linux/mtd/physmap.h
+++ b/include/linux/mtd/physmap.h
@@ -19,6 +19,7 @@
 #include <linux/mtd/partitions.h>
 
 struct map_info;
+struct platform_device;
 
 struct physmap_flash_data {
 	unsigned int		width;
-- 
1.7.2.3

