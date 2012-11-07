Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2KGKsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:48:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab2KGKss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:48:48 -0500
X-IronPort-AV: E=Sophos;i="4.80,729,1344182400"; 
   d="scan'208";a="6154925"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 1/5] virtio-scsi: remove the useless assignment
Date: Wed, 7 Nov 2012 18:18:10 +0800
Message-Id: <1352283494-31200-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 18:17:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/07 18:17:57,
	Serialize complete at 2012/11/07 18:17:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reassign err is not needed, just a cleanup.

Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d5f9f45..8746c37 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -669,7 +669,6 @@ static int virtscsi_init(struct virtio_device *vdev,
 			goto out;
 		}
 	}
-	err = 0;
 
 out:
 	if (err)
-- 
1.8.0

