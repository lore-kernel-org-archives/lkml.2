Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1DYUYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:11 -0400
Received: from 1wt.eu ([62.212.114.60]:33915 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab1DYUYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:08 -0400
Message-Id: <20110425200235.342580584@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 054/173] acer-wmi: Fix capitalisation of GUID
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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

--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -90,7 +90,7 @@ struct acer_quirks {
  */
 #define AMW0_GUID1		"67C3371D-95A3-4C37-BB61-DD47B491DAAB"
 #define AMW0_GUID2		"431F16ED-0C2B-444C-B267-27DEB140CF9C"
-#define WMID_GUID1		"6AF4F258-B401-42fd-BE91-3D4AC2D7C0D3"
+#define WMID_GUID1		"6AF4F258-B401-42FD-BE91-3D4AC2D7C0D3"
 #define WMID_GUID2		"95764E09-FB56-4e83-B31A-37761F60994A"
 
 MODULE_ALIAS("wmi:67C3371D-95A3-4C37-BB61-DD47B491DAAB");


