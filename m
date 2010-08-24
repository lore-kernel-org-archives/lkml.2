Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746Ab0HXXDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:52 -0400
Received: from kroah.org ([198.145.64.141]:32855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933658Ab0HXXDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:41 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:10 2010
Message-Id: <20100824224510.125443543@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anatolij Gustschin <agust@denx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [102/114] powerpc: Fix typo in uImage target
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit c686ecf5040d287a68d4fca7f1948472f556a6d3 upstream.

Commit e32e78c5ee8aadef020fbaecbe6fb741ed9029fd
(powerpc: fix build with make 3.82) introduced a
typo in uImage target and broke building uImage:

make: *** No rule to make target `uImage'.  Stop.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -164,7 +164,7 @@ drivers-$(CONFIG_OPROFILE)	+= arch/power
 all: zImage
 
 # With make 3.82 we cannot mix normal and wildcard targets
-BOOT_TARGETS1 := zImage zImage.initrd uImaged
+BOOT_TARGETS1 := zImage zImage.initrd uImage
 BOOT_TARGETS2 := zImage% dtbImage% treeImage.% cuImage.% simpleImage.%
 
 PHONY += $(BOOT_TARGETS1) $(BOOT_TARGETS2)


