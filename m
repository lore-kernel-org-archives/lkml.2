Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1EVLms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:42:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65085 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab1EVLmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:42:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Bt3AJc4r9NoqprZ4jApqvzAxqPqKJPYIVkyivuBtjPWuDEK1O5jdW8DqAJ67QqEknn
         HYp76+aTWMf4srMCNnMNO6TNTLGdHTsqZkQzQaGBE+Ih74F+6mAnHDeBwvxzTfBRQ4Sy
         8W9ouYV8iPT9nu8DzV980rB5g/gPlR20ioBxA=
MIME-Version: 1.0
Date: Sun, 22 May 2011 19:42:41 +0800
Message-ID: <BANLkTinMt_Mh=fy5GOpx6G0TpWmyTn2d3g@mail.gmail.com>
Subject: [Patch] cris: fix a build error in sync_serial_open()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Content-Type: multipart/mixed; boundary=20cf30363929441bad04a3dbdac6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30363929441bad04a3dbdac6
Content-Type: text/plain; charset=UTF-8

This patch fixes such a build error on cris:

arch/cris/arch-v10/drivers/sync_serial.c:628: error: 'ret' undeclared
(first use in this function)

'ret' should be 'err'.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---

--20cf30363929441bad04a3dbdac6
Content-Type: text/x-patch; charset=US-ASCII; 
	name="cris-fix-build-error-in-sync_serial_open.diff"
Content-Disposition: attachment; 
	filename="cris-fix-build-error-in-sync_serial_open.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnzx1kge1

ZGlmZiAtLWdpdCBhL2FyY2gvY3Jpcy9hcmNoLXYxMC9kcml2ZXJzL3N5bmNfc2VyaWFsLmMgYi9h
cmNoL2NyaXMvYXJjaC12MTAvZHJpdmVycy9zeW5jX3NlcmlhbC5jCmluZGV4IDg1MDI2NTM3Li5k
MmFkOWU3IDEwMDY0NAotLS0gYS9hcmNoL2NyaXMvYXJjaC12MTAvZHJpdmVycy9zeW5jX3Nlcmlh
bC5jCisrKyBiL2FyY2gvY3Jpcy9hcmNoLXYxMC9kcml2ZXJzL3N5bmNfc2VyaWFsLmMKQEAgLTYy
NSwxMSArNjI1LDExIEBAIHN0YXRpYyBpbnQgc3luY19zZXJpYWxfb3BlbihzdHJ1Y3QgaW5vZGUg
Kmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKIAkJCSpSX0lSUV9NQVNLMV9TRVQgPSAxIDw8IHBv
cnQtPmRhdGFfYXZhaWxfYml0OwogCQlERUJVRyhwcmludGsoS0VSTl9ERUJVRyAic3NlciVkIHJl
YyBzdGFydGVkXG4iLCBkZXYpKTsKIAl9Ci0JcmV0ID0gMDsKKwllcnIgPSAwOwogCQogb3V0Ogog
CW11dGV4X3VubG9jaygmc3luY19zZXJpYWxfbXV0ZXgpOwotCXJldHVybiByZXQ7CisJcmV0dXJu
IGVycjsKIH0KIAogc3RhdGljIGludCBzeW5jX3NlcmlhbF9yZWxlYXNlKHN0cnVjdCBpbm9kZSAq
aW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQo=
--20cf30363929441bad04a3dbdac6--
