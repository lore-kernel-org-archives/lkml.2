Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab1BVWZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:25:44 -0500
Received: from kroah.org ([198.145.64.141]:32985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1BVWW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:43 2011
Message-Id: <20110222221842.913150648@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: [59/70] acer-wmi: Fix capitalisation of GUID
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit bbb706079abe955a9e3f208f541de97d99449236 upstream.

6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3 needs to be
6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3 to match the hardware alias.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/acer-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -80,7 +80,7 @@ MODULE_LICENSE("GPL");
  */
 #define AMW0_GUID1		"67C3371D-95A3-4C37-BB61-DD47B491DAAB"
 #define AMW0_GUID2		"431F16ED-0C2B-444C-B267-27DEB140CF9C"
-#define WMID_GUID1		"6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3"
+#define WMID_GUID1		"6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3"
 #define WMID_GUID2		"95764E09-FB56-4e83-B31A-37761F60994A"
 
 MODULE_ALIAS("wmi:67C3371D-95A3-4C37-BB61-DD47B491DAAB");


