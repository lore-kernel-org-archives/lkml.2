Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2CSCOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:14:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59860 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507Ab2CSCOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:14:40 -0400
MIME-Version: 1.0
Date: Sun, 18 Mar 2012 22:14:39 -0400
X-Google-Sender-Auth: P-P4URLb22L6P1-aSod6PtLOOKY
Message-ID: <CAOcJUbxrPtAWGeHz1uxTPuqAHFUq6f=NVx1KZRiWLkYSWTFiwg@mail.gmail.com>
Subject: [v3.3 BUG FIX] mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=90e6ba4fc346e4f2aa04bb8f1e89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba4fc346e4f2aa04bb8f1e89
Content-Type: text/plain; charset=ISO-8859-1

I just tested Linux 3.3-rc7 and found that my mxl111sf driver was
broken!!  The fix was easy to find...

Hopefully we can get this fix merged before Linus releases 3.3 --
Please do whatever it takes to get this into mainline.

Thanks & best regards,

Mike Krufky

The following changes since commit 632fba4d012458fd5fedc678fb9b0f8bc59ceda2:
  Sander Eikelenboom (1):
        [media] cx25821: Add a card definition for "No brand" cards
that have: subvendor = 0x0000 subdevice = 0x0000

are available in the git repository at:

  git://linuxtv.org/mkrufky/mxl111sf aero-m

Michael Krufky (1):
      mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()

 drivers/media/dvb/dvb-usb/mxl111sf.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

--90e6ba4fc346e4f2aa04bb8f1e89
Content-Type: application/octet-stream; 
	name=bc93326ce5869486c33dbb98596a8a3758c6266d
Content-Disposition: attachment; 
	filename=bc93326ce5869486c33dbb98596a8a3758c6266d
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gzyvntbf0

RnJvbTogTWljaGFlbCBLcnVma3kgPG1rcnVma3lAbGludXh0di5vcmc+CkRhdGU6IFN1biwgMTgg
TWFyIDIwMTIgMTc6MzU6NTcgKzAwMDAgKC0wNDAwKQpTdWJqZWN0OiBteGwxMTFzZjogZml4IGVy
cm9yIG9uIHN0cmVhbSBzdG9wIGluIG14bDExMXNmX2VwNl9zdHJlYW1pbmdfY3RybCgpClgtR2l0
LVVybDogaHR0cDovL2dpdC5saW51eHR2Lm9yZwoKbXhsMTExc2Y6IGZpeCBlcnJvciBvbiBzdHJl
YW0gc3RvcCBpbiBteGwxMTFzZl9lcDZfc3RyZWFtaW5nX2N0cmwoKQoKUmVtb3ZlIHVubmVjZXNz
YXJ5IHJlZ2lzdGVyIGFjY2VzcyBpbiBteGwxMTFzZl9lcDZfc3RyZWFtaW5nX2N0cmwoKQoKVGhp
cyBjb2RlIGJyZWFrcyBkcml2ZXIgb3BlcmF0aW9uIGluIGtlcm5lbCAzLjMgYW5kIGxhdGVyLCBh
bHRob3VnaAppdCB3b3JrcyBwcm9wZXJseSBpbiAzLjIgIERpc2FibGUgcmVnaXN0ZXIgYWNjZXNz
IHRvIDB4MTIgZm9yIG5vdy4KClNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgS3J1Zmt5IDxta3J1Zmt5
QGxpbnV4dHYub3JnPgotLS0KCmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNi
L214bDExMXNmLmMgYi9kcml2ZXJzL21lZGlhL2R2Yi9kdmItdXNiL214bDExMXNmLmMKaW5kZXgg
MzhlZjAyNS4uODEzMDVkZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9kdmIvZHZiLXVzYi9t
eGwxMTFzZi5jCisrKyBiL2RyaXZlcnMvbWVkaWEvZHZiL2R2Yi11c2IvbXhsMTExc2YuYwpAQCAt
MzUxLDE1ICszNTEsMTMgQEAgc3RhdGljIGludCBteGwxMTFzZl9lcDZfc3RyZWFtaW5nX2N0cmwo
c3RydWN0IGR2Yl91c2JfYWRhcHRlciAqYWRhcCwgaW50IG9ub2ZmKQogCQkJCQkgICAgICBhZGFw
X3N0YXRlLT5lcDZfY2xvY2twaGFzZSwKIAkJCQkJICAgICAgMCwgMCk7CiAJCW14bF9mYWlsKHJl
dCk7CisjaWYgMAogCX0gZWxzZSB7CiAJCXJldCA9IG14bDExMXNmX2Rpc2FibGVfNjU2X3BvcnQo
c3RhdGUpOwogCQlteGxfZmFpbChyZXQpOworI2VuZGlmCiAJfQogCi0JbXhsMTExc2ZfcmVhZF9y
ZWcoc3RhdGUsIDB4MTIsICZ0bXApOwotCXRtcCAmPSB+MHgwNDsKLQlteGwxMTFzZl93cml0ZV9y
ZWcoc3RhdGUsIDB4MTIsIHRtcCk7Ci0KIAlyZXR1cm4gcmV0OwogfQogCg==
--90e6ba4fc346e4f2aa04bb8f1e89--
