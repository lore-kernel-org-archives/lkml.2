Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1AQJnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 04:43:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1AQJnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 04:43:03 -0500
Date: Mon, 17 Jan 2011 11:42:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] virtio-net: fix a typo
Message-ID: <20110117094228.GE23479@redhat.com>
References: <1295252059-27438-1-git-send-email-aurelien@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295252059-27438-1-git-send-email-aurelien@aurel32.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 09:14:19AM +0100, Aurelien Jarno wrote:
> fitler -> filter
> 
> Cc: netdev@vger.kernel.org
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

Acked-by: Michael S. Tsirkin <mst@redhat.com>
obviously.

Cc:
virtualization@lists.linux-foundation.org
rusty@rustcorp.com.au
as well.

BTW Rusty, ./scripts/get_maintainer.pl doesn't work
for most of virtio since there is no entry in MAINTAINERS for virtio
net/block/core.  Adding it will help people know whom to contact
with issues/patches. It will also help if
I am Cc'd on patches as this way I won't forget to
review them.

--->
Add MAINTAINERS entry for virtio core, net, block

Patches should keep coming through Rusty but it
helps if I'm Cc'd as well.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----

Comments?

diff --git a/MAINTAINERS b/MAINTAINERS
index 23d0436..7de75ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6439,6 +6439,16 @@ S:	Maintained
 F:	drivers/char/virtio_console.c
 F:	include/linux/virtio_console.h
 
+VIRTIO CORE, NET AND BLOCK DRIVERS
+M:	Rusty Russell <rusty@rustcorp.com.au>
+M:	"Michael S. Tsirkin" <mst@redhat.com>
+L:	virtualization@lists.linux-foundation.org
+S:	Maintained
+F:	drivers/virtio/
+F:	drivers/net/virtio_net.c
+F:	drivers/block/virtio_blk.c
+F:	include/linux/virtio_*.h
+
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
 L:	kvm@vger.kernel.org
