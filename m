Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1JSFdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 01:33:41 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:27685 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1JSFdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 01:33:40 -0400
X-Loopcount0: from 10.170.28.39
From: <Srinivas_G_Gowda@Dell.com>
To: <linux-kernel@vger.kernel.org>
CC: <minyard@acm.org>
Date: Tue, 18 Oct 2011 22:31:13 -0700
Subject: [PATCH] ipmi: This patch decreases the IPMI message transaction
 time in Interrupt mode
Thread-Topic: [PATCH] ipmi: This patch decreases the IPMI message
 transaction time in Interrupt mode
Thread-Index: AcyOIKTviBu2FbqLS/6uRaFWgULH6A==
Message-ID: <4E9E60A1.4090408@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
acceptlanguage: en-US
Content-Type: multipart/mixed; boundary="_002_4E9E60A14090408dellcom_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_4E9E60A14090408dellcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


--_002_4E9E60A14090408dellcom_
Content-Type: text/plain; name="0001-ipmi-interrupt-fast-transaction.patch"
Content-Description: 0001-ipmi-interrupt-fast-transaction.patch
Content-Disposition: attachment;
	filename="0001-ipmi-interrupt-fast-transaction.patch"; size=1387;
	creation-date="Wed, 19 Oct 2011 05:33:34 GMT";
	modification-date="Wed, 19 Oct 2011 05:33:34 GMT"
Content-Transfer-Encoding: base64

U3ViamVjdDogW1BBVENIXSBUaGlzIHBhdGNoICBkZWNyZWFzZXMgdGhlIElQTUkgbWVzc2FnZSB0
cmFuc2FjdGlvbiB0aW1lIGluIEludGVycnVwdCBtb2RlDQogLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQogSW4gZnVuY3Rpb24gc2VuZGVyKCksIHN0YXJ0X25leHRfbXNnKHNt
aV9pbmZvKSBpcyB3aGVuIHRoZSBkcml2ZXIgaXMgcmVhZHkgdG8gc2VuZCB0aGUgZGF0YSB0byBC
TUMsDQogYnV0IGNvdW50cyBvbiB0aGUgdGltZW91dCB0byBzdGFydCB0aGUgdHJhbnNhY3Rpb24u
SW4gaW50ZXJydXB0IG1vZGUgd2hhdCBJIG9ic2VydmVkIGlzIHRoYXQgZHJpdmVyDQogc2ltcGx5
IHdhc3RlcyB0aW1lLCBjb3VudGluZyBvbiB0aGUgdGltZXIgdG8gdHJpZ2dlciB0aGUgdHJhbnNh
Y3Rpb24uICBXaGF0IEkgaGF2ZSBkb25lIGhlcmUgaXMgdG8NCiBjdXQgdGhlIHdhaXQsYW5kIHRy
aWdnZXIgdGhlIGNhbGwgdG8gdGhlIGhhbmRsZXIuDQogVGhpcyBwYXRjaCBjb25zaWRlcmFibHkg
ZGVjcmVhc2VzIHRoZSBJUE1JIHRyYW5zYWN0aW9uIHRpbWUgKGN1dHMgb2ZmIH45bXMgZm9yIGEg
c2luZ2xlIGlwbWl0b29sIHRyYW5zYWN0aW9uKS4NCg0KIFNpZ25lZC1vZmYtYnk6IFNyaW5pdmFz
X0dvd2RhIDxzcmluaXZhc19nX2dvd2RhQGRlbGwuY29tPg0KLS0tDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9jaGFyL2lwbWkvaXBtaV9zaV9pbnRmLmMgYi9kcml2ZXJzL2NoYXIvaXBtaS9pcG1pX3Np
X2ludGYuYw0KaW5kZXggOTM5N2FiNC4uNWQxZTBjYSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvY2hh
ci9pcG1pL2lwbWlfc2lfaW50Zi5jDQorKysgYi9kcml2ZXJzL2NoYXIvaXBtaS9pcG1pX3NpX2lu
dGYuYw0KQEAgLTkzMiw4ICs5MzIsMTAgQEAgc3RhdGljIHZvaWQgc2VuZGVyKHZvaWQgICAgICAg
ICAgICAgICAgKnNlbmRfaW5mbywNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc21pX2luZm8t
Pm1zZ19sb2NrLCBmbGFncyk7DQogDQogCXNwaW5fbG9ja19pcnFzYXZlKCZzbWlfaW5mby0+c2lf
bG9jaywgZmxhZ3MpOw0KLQlpZiAoc21pX2luZm8tPnNpX3N0YXRlID09IFNJX05PUk1BTCAmJiBz
bWlfaW5mby0+Y3Vycl9tc2cgPT0gTlVMTCkNCisJaWYgKHNtaV9pbmZvLT5zaV9zdGF0ZSA9PSBT
SV9OT1JNQUwgJiYgc21pX2luZm8tPmN1cnJfbXNnID09IE5VTEwpIHsNCiAJCXN0YXJ0X25leHRf
bXNnKHNtaV9pbmZvKTsNCisJCW1vZF90aW1lcigmc21pX2luZm8tPnNpX3RpbWVyLCBqaWZmaWVz
ICsgMSk7DQorCX0NCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc21pX2luZm8tPnNpX2xvY2ss
IGZsYWdzKTsNCiB9DQogDQoNCg==

--_002_4E9E60A14090408dellcom_--
