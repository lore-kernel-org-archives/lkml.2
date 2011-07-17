Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab1GQJxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:53:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1GQJxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:53:40 -0400
MIME-Version: 1.0
Date: Sun, 17 Jul 2011 17:53:39 +0800
Message-ID: <CAM_iQpX84cR+9s3nL-p5V3a=bQgmRwJ5jhWpLY0WNS3TO8f8LQ@mail.gmail.com>
Subject: [Patch] fusb300_udc: remove unused function fusb300_ep0_complete()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: linux-usb@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Felipe Balbi <balbi@ti.com>
Content-Type: multipart/mixed; boundary=90e6ba2123916a25ae04a840dbeb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba2123916a25ae04a840dbeb
Content-Type: text/plain; charset=UTF-8

It is not used, so just remove it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---

--90e6ba2123916a25ae04a840dbeb
Content-Type: text/x-patch; charset=US-ASCII; 
	name="drivers-usb-gadget-fusb300_udc-remove-unused.diff"
Content-Disposition: attachment; 
	filename="drivers-usb-gadget-fusb300_udc-remove-unused.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gq7tu4cl0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2dhZGdldC9mdXNiMzAwX3VkYy5jIGIvZHJpdmVycy91
c2IvZ2FkZ2V0L2Z1c2IzMDBfdWRjLmMKaW5kZXggNzYzZDQ2Mi4uM2VmZDM0ZDMgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvdXNiL2dhZGdldC9mdXNiMzAwX3VkYy5jCisrKyBiL2RyaXZlcnMvdXNiL2dh
ZGdldC9mdXNiMzAwX3VkYy5jCkBAIC05ODAsMTAgKzk4MCw2IEBAIHN0YXRpYyB2b2lkIHNldF9h
ZGRyZXNzKHN0cnVjdCBmdXNiMzAwICpmdXNiMzAwLCBzdHJ1Y3QgdXNiX2N0cmxyZXF1ZXN0ICpj
dHJsKQogCQl9IFwKIAl9IHdoaWxlICgwKQogCi1zdGF0aWMgdm9pZCBmdXNiMzAwX2VwMF9jb21w
bGV0ZShzdHJ1Y3QgdXNiX2VwICplcCwKLQkJCQlzdHJ1Y3QgdXNiX3JlcXVlc3QgKnJlcSkKLXsK
LX0KIAogc3RhdGljIGludCBzZXR1cF9wYWNrZXQoc3RydWN0IGZ1c2IzMDAgKmZ1c2IzMDAsIHN0
cnVjdCB1c2JfY3RybHJlcXVlc3QgKmN0cmwpCiB7Cg==
--90e6ba2123916a25ae04a840dbeb--
