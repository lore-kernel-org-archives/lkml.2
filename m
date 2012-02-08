Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2BHQrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:47:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab2BHQrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:47:35 -0500
Date: Wed, 8 Feb 2012 18:47:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dongsu Park <advance38@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tools/virtio: Compile errors
Message-ID: <20120208164736.GA31066@redhat.com>
References: <20120208160405.GA1587@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120208160405.GA1587@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 05:04:05PM +0100, Dongsu Park wrote:
> Hi,
> 
> there are compile problems under tools/virtio.
> If I simply run make,
> 
> ~/linuxsrc/linux-3.2/tools/virtio $ make
> gcc -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign
> -fno-strict-overflow  -MMD   -c -o virtio_ring.o
> ../../drivers/virtio/virtio_ring.c
> ../../drivers/virtio/virtio_ring.c:24:26: fatal error: linux/module.h:
> No such file or directory
> compilation terminated.
> make: *** [virtio_ring.o] Error 1


> By the way, my system is Ubuntu 11.10 with Kernel 3.2.
> 
> Cheers,
> Dongsu

This patch is missing - I'll put it upstream.

--->

tools/virtio: add module.h stub

make it build with linux 3.2

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/tools/virtio/linux/module.h b/tools/virtio/linux/module.h
new file mode 100644
index 0000000..96868eb
--- /dev/null
+++ b/tools/virtio/linux/module.h
@@ -0,0 +1,3 @@
+#ifndef LINUX_MODULE_H
+#define LINUX_MODULE_H
+#endif
