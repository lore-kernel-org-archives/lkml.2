Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab1EVOVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:21:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33807 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1EVOVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=TuXT09je6zbFdeIi++D8cfu03ZO1zvDyFM3P5mj1KgzHf9cp4IZNTHue1EP3b300Sd
         2Du02oQaU2c+YI35wQI9EofBkLGms395pHThLOg3IJz8fDqyFlb+H4G6r6/0EBN/aU9o
         de5GKahbhUjItRq5u5NaUeE077bTbbQTGhd4E=
MIME-Version: 1.0
Date: Sun, 22 May 2011 22:21:44 +0800
Message-ID: <BANLkTikwgigy0yNeo1iy+DOB3+rmkLa4SA@mail.gmail.com>
Subject: [Patch] cris: fix the prototype of sync_serial_ioctl()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Content-Type: multipart/mixed; boundary=0003255755d60e291e04a3de1370
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0003255755d60e291e04a3de1370
Content-Type: text/plain; charset=UTF-8

This patch fixes such a build error on cris:

arch/cris/arch-v10/drivers/sync_serial.c:961: error: conflicting types
for 'sync_serial_ioctl'

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---

--0003255755d60e291e04a3de1370
Content-Type: text/x-patch; charset=US-ASCII; 
	name="cris-fix-build-error-in-sync_serial_ioctl.diff"
Content-Disposition: attachment; 
	filename="cris-fix-build-error-in-sync_serial_ioctl.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go02rs2y1

ZGlmZiAtLWdpdCBhL2FyY2gvY3Jpcy9hcmNoLXYxMC9kcml2ZXJzL3N5bmNfc2VyaWFsLmMgYi9h
cmNoL2NyaXMvYXJjaC12MTAvZHJpdmVycy9zeW5jX3NlcmlhbC5jCmluZGV4IDg1MDI2NTM3Li40
MzUyZjIzIDEwMDY0NAotLS0gYS9hcmNoL2NyaXMvYXJjaC12MTAvZHJpdmVycy9zeW5jX3Nlcmlh
bC5jCisrKyBiL2FyY2gvY3Jpcy9hcmNoLXYxMC9kcml2ZXJzL3N5bmNfc2VyaWFsLmMKQEAgLTE1
OCw3ICsxNTgsNyBAQCBzdGF0aWMgaW50IHN5bmNfc2VyaWFsX29wZW4oc3RydWN0IGlub2RlICpp
bm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpOwogc3RhdGljIGludCBzeW5jX3NlcmlhbF9yZWxlYXNl
KHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKTsKIHN0YXRpYyB1bnNpZ25l
ZCBpbnQgc3luY19zZXJpYWxfcG9sbChzdHJ1Y3QgZmlsZSAqZmlscCwgcG9sbF90YWJsZSAqd2Fp
dCk7CiAKLXN0YXRpYyBpbnQgc3luY19zZXJpYWxfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGUsCitz
dGF0aWMgbG9uZyBzeW5jX3NlcmlhbF9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZSwKIAl1bnNpZ25l
ZCBpbnQgY21kLCB1bnNpZ25lZCBsb25nIGFyZyk7CiBzdGF0aWMgc3NpemVfdCBzeW5jX3Nlcmlh
bF93cml0ZShzdHJ1Y3QgZmlsZSAqZmlsZSwgY29uc3QgY2hhciAqYnVmLAogCXNpemVfdCBjb3Vu
dCwgbG9mZl90ICpwcG9zKTsK
--0003255755d60e291e04a3de1370--
