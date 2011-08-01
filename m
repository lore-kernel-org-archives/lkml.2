Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1HAX1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:27:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100Ab1HAX1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:27:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:53 2011
Message-Id: <20110801232053.577190050@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [30/70] drm/radeon/kms: fix backend map typo on juniper
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 9a4a0b9c9fa6ad9902f49801d7b770462b69c4d3 upstream.

Don't enable backends that don't exist.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1900,7 +1900,7 @@ static void evergreen_gpu_init(struct ra
 			gb_backend_map = 0x66442200;
 			break;
 		case CHIP_JUNIPER:
-			gb_backend_map = 0x00006420;
+			gb_backend_map = 0x00002200;
 			break;
 		default:
 			gb_backend_map =


