Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab0IDIqg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 04:46:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60535 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0IDIqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 04:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=jmvkAlZaMSemE0P9rXKLZZwjBr6eWdq1RBiA5VDHK/w6PBOAVV9jHWuB6eJYmDNesk
         0MkAvGTokyZRZDEnfJ97lxGBAwD69dDSbi6DMymIcZl8Xx70y3v87NHxrGRUxfewR+Fs
         /vCVyGsZoyW7vOGEYohC5JNilKlCGpRp0J68U=
MIME-Version: 1.0
Date: Sat, 4 Sep 2010 14:16:33 +0530
Message-ID: <AANLkTimFNum+dPcb6+UWFSm-Urr9mYnVMypOQahCfnhg@mail.gmail.com>
Subject: [PATCH] HPET: Supporting info for hpet_example
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00163646ced2a0082a048f6b15f6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163646ced2a0082a048f6b15f6
Content-Type: text/plain; charset=ISO-8859-1

Hello,

I am attaching the patch and also uploaded on :
http://userweb.kernel.org/~jaswinder/patches/0001-HPET-Supporting-info-for-hpet_example.patch

Thanks,
--
Jaswinder Singh.

--00163646ced2a0082a048f6b15f6
Content-Type: application/octet-stream; 
	name="0001-HPET-Supporting-info-for-hpet_example.patch"
Content-Disposition: attachment; 
	filename="0001-HPET-Supporting-info-for-hpet_example.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gdo8ahc50

RnJvbSA5MmY0ZDc5MGYwZDFjMTM4MmMzNzQ3MTllOTkyYTY4OWJjMDZkOGZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXN3aW5kZXIgU2luZ2ggUmFqcHV0IDxqYXN3aW5kZXJyYWpw
dXRAZ21haWwuY29tPgpEYXRlOiBTYXQsIDQgU2VwIDIwMTAgMTM6NTk6NTcgKzA1MzAKU3ViamVj
dDogW1BBVENIXSBIUEVUOiBTdXBwb3J0aW5nIGluZm8gZm9yIGhwZXRfZXhhbXBsZQoKJC4vaHBl
dF9leGFtcGxlIGluZm8gL2Rldi9ocGV0Ci1ocGV0OiBleGVjdXRpbmcgaW5mbwpocGV0X2luZm86
IGhpX2lycWZyZXEgMHgwIGhpX2ZsYWdzIDB4MCBoaV9ocGV0IDAgaGlfdGltZXIgMgoKU2lnbmVk
LW9mZi1ieTogSmFzd2luZGVyIFNpbmdoIFJhanB1dCA8amFzd2luZGVycmFqcHV0QGdtYWlsLmNv
bT4KQ2M6IENsZW1lbnMgTGFkaXNjaCA8Y2xlbWVuc0BsYWRpc2NoLmRlPgpDYzogIlZlbmthdGVz
aCBQYWxsaXBhZGkgKFZlbmtpKSIgPHZlbmtpQGdvb2dsZS5jb20+Ci0tLQogRG9jdW1lbnRhdGlv
bi90aW1lcnMvaHBldF9leGFtcGxlLmMgfCAgIDI3ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KwogMSBmaWxlcyBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdGltZXJzL2hwZXRfZXhhbXBsZS5jIGIvRG9jdW1lbnRh
dGlvbi90aW1lcnMvaHBldF9leGFtcGxlLmMKaW5kZXggNGJmYWZiNy4uOWEzZTcwMSAxMDA2NDQK
LS0tIGEvRG9jdW1lbnRhdGlvbi90aW1lcnMvaHBldF9leGFtcGxlLmMKKysrIGIvRG9jdW1lbnRh
dGlvbi90aW1lcnMvaHBldF9leGFtcGxlLmMKQEAgLTk3LDYgKzk3LDMzIEBAIGhwZXRfb3Blbl9j
bG9zZShpbnQgYXJnYywgY29uc3QgY2hhciAqKmFyZ3YpCiB2b2lkCiBocGV0X2luZm8oaW50IGFy
Z2MsIGNvbnN0IGNoYXIgKiphcmd2KQogeworCXN0cnVjdCBocGV0X2luZm8JaW5mbzsKKwlpbnQJ
CQlmZDsKKworCWlmIChhcmdjICE9IDEpIHsKKwkJZnByaW50ZihzdGRlcnIsICJocGV0X2luZm86
IGRldmljZS1uYW1lXG4iKTsKKwkJcmV0dXJuOworCX0KKworCWZkID0gb3Blbihhcmd2WzBdLCBP
X1JET05MWSk7CisJaWYgKGZkIDwgMCkgeworCQlmcHJpbnRmKHN0ZGVyciwgImhwZXRfaW5mbzog
b3BlbiBvZiAlcyBmYWlsZWRcbiIsIGFyZ3ZbMF0pOworCQlyZXR1cm47CisJfQorCisJaWYgKGlv
Y3RsKGZkLCBIUEVUX0lORk8sICZpbmZvKSA8IDApIHsKKwkJZnByaW50ZihzdGRlcnIsICJocGV0
X2luZm86IGZhaWxlZCB0byBnZXQgaW5mb1xuIik7CisJCWdvdG8gb3V0OworCX0KKworCWZwcmlu
dGYoc3RkZXJyLCAiaHBldF9pbmZvOiBoaV9pcnFmcmVxIDB4JWx4IGhpX2ZsYWdzIDB4JWx4ICIs
CisJCWluZm8uaGlfaXJlcWZyZXEsIGluZm8uaGlfZmxhZ3MpOworCWZwcmludGYoc3RkZXJyLCAi
aGlfaHBldCAlZCBoaV90aW1lciAlZFxuIiwKKwkJaW5mby5oaV9ocGV0LCBpbmZvLmhpX3RpbWVy
KTsKKworb3V0OgorCWNsb3NlKGZkKTsKKwlyZXR1cm47CiB9CiAKIHZvaWQKLS0gCjEuNy4xLjEK
Cg==
--00163646ced2a0082a048f6b15f6--
