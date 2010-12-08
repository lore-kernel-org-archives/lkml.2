Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0LHBBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:45 -0500
Received: from kroah.org ([198.145.64.141]:49057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab0LHBBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:42 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.009589546@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [146/289] [media] drivers/media/video/cx23885/cx23885-core.c: fix cx23885_dev_checkrevision()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit abe1def46d84aa27d3f84d729204b162e8c64d76 upstream.

It was missing the `break'.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=18672

Reported-by: Igor <i2g2r2@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx23885/cx23885-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -815,6 +815,7 @@ static void cx23885_dev_checkrevision(st
 	case 0x0e:
 		/* CX23887-15Z */
 		dev->hwrevision = 0xc0;
+		break;
 	case 0x0f:
 		/* CX23887-14Z */
 		dev->hwrevision = 0xb1;


