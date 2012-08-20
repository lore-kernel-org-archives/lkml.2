Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2HTD7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:59:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59366 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2HTD7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:59:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 03/46] nouveau: fixup scanout enable in nvc0_pm
Date: Sun, 19 Aug 2012 20:58:39 -0700
Message-Id: <20120820035832.731652427@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <maarten.lankhorst@canonical.com>

commit 44b9f44e111c1e4a50bff66a642cc7c5cb59af4e upstream.

Fixes screen being black after changing performance level.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nvc0_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvc0_pm.c
+++ b/drivers/gpu/drm/nouveau/nvc0_pm.c
@@ -557,7 +557,7 @@ prog_mem(struct drm_device *dev, struct
 	nouveau_mem_exec(&exec, info->perflvl);
 
 	if (dev_priv->chipset < 0xd0)
-		nv_wr32(dev, 0x611200, 0x00003300);
+		nv_wr32(dev, 0x611200, 0x00003330);
 	else
 		nv_wr32(dev, 0x62c000, 0x03030300);
 }


