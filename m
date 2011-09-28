Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1I1WlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab1I1WlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:34 2011
Message-Id: <20110928220133.956538226@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Venkateswararao=20Jujjuri=20@suse.de,
        "?= <jvrao@linux.vnet.ibm.com>, Eric Van Hensbergen <ericvh@gmail.com>"@suse.de
Subject: [082/244] VirtIO can transfer VIRTQUEUE_NUM of pages.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: jvrao <jvrao@linux.vnet.ibm.com>

commit 7f781679dd596c8abde8336b4d0d166d6a4aad04 upstream.

Signed-off-by: Venkateswararao Jujjuri "<jvrao@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/9p/trans_virtio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -592,7 +592,7 @@ static struct p9_trans_module p9_virtio_
 	.close = p9_virtio_close,
 	.request = p9_virtio_request,
 	.cancel = p9_virtio_cancel,
-	.maxsize = PAGE_SIZE*16,
+	.maxsize = PAGE_SIZE*VIRTQUEUE_NUM,
 	.pref = P9_TRANS_PREF_PAYLOAD_SEP,
 	.def = 0,
 	.owner = THIS_MODULE,


