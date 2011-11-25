Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab1KYMgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:36:00 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:4781 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab1KYMf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:35:59 -0500
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 07:35:59 EST
X-Loopcount0: from 10.175.216.249
From: <Srinivas_G_Gowda@Dell.com>
To: <linux-kernel@vger.kernel.org>, <minyard@acm.org>
Date: Fri, 25 Nov 2011 17:51:58 +0530
Subject: Re: [PATCH] ipmi: This patch decreases the IPMI message transaction
 time in Interrupt mode
Thread-Topic: [PATCH] ipmi: This patch decreases the IPMI message
 transaction time in Interrupt mode
Thread-Index: AcyrbXb7SQ12yADBTke0vaK2dWyj2g==
Message-ID: <4ECF8866.5030601@dell.com>
References: <4E9E60A1.4090408@dell.com>
In-Reply-To: <4E9E60A1.4090408@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
acceptlanguage: en-US
Content-Type: multipart/mixed; boundary="_002_4ECF88665030601dellcom_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_4ECF88665030601dellcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 10/19/2011 11:01 AM, Gowda, Srinivas G wrote:

--_002_4ECF88665030601dellcom_
Content-Type: text/plain; name="0001-ipmi-interrupt-fast-transaction.patch"
Content-Description: 0001-ipmi-interrupt-fast-transaction.patch
Content-Disposition: attachment;
	filename="0001-ipmi-interrupt-fast-transaction.patch"; size=1081;
	creation-date="Fri, 25 Nov 2011 12:26:32 GMT";
	modification-date="Fri, 25 Nov 2011 12:26:32 GMT"
Content-Transfer-Encoding: base64

U3ViamVjdDogW1BBVENIXSBUaGlzIHBhdGNoICBkZWNyZWFzZXMgdGhlIElQTUkgbWVzc2FnZSB0
cmFuc2FjdGlvbiB0aW1lIGluIEludGVycnVwdCBtb2RlDQogLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQogV2hhdCBJIGhhdmUgZG9uZSB0aGlzIHRpbWUgaXMgdG8gZGlyZWN0
bHkgY2FsbCB0aGUgaGFuZGxlcg0KIA0KIFRoaXMgcGF0Y2ggY29uc2lkZXJhYmx5IGRlY3JlYXNl
cyB0aGUgSVBNSSB0cmFuc2FjdGlvbiB0aW1lIChjdXRzIG9mZiB+OW1zIGZvciBhIHNpbmdsZSBp
cG1pdG9vbCB0cmFuc2FjdGlvbikuDQoNCiBTaWduZWQtb2ZmLWJ5OiBTcmluaXZhc19Hb3dkYSA8
c3Jpbml2YXNfZ19nb3dkYUBkZWxsLmNvbT4NCi0tLQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2hh
ci9pcG1pL2lwbWlfc2lfaW50Zi5jIGIvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9zaV9pbnRmLmMN
CmluZGV4IDkzOTdhYjQuLjVkMWUwY2EgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2NoYXIvaXBtaS9p
cG1pX3NpX2ludGYuYw0KKysrIGIvZHJpdmVycy9jaGFyL2lwbWkvaXBtaV9zaV9pbnRmLmMNCkBA
IC05MzIsOCArOTMyLDEwIEBAIHN0YXRpYyB2b2lkIHNlbmRlcih2b2lkICAgICAgICAgICAgICAg
ICpzZW5kX2luZm8sDQogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnNtaV9pbmZvLT5tc2dfbG9j
aywgZmxhZ3MpOw0KIA0KIAlzcGluX2xvY2tfaXJxc2F2ZSgmc21pX2luZm8tPnNpX2xvY2ssIGZs
YWdzKTsNCi0JaWYgKHNtaV9pbmZvLT5zaV9zdGF0ZSA9PSBTSV9OT1JNQUwgJiYgc21pX2luZm8t
PmN1cnJfbXNnID09IE5VTEwpDQorCWlmIChzbWlfaW5mby0+c2lfc3RhdGUgPT0gU0lfTk9STUFM
ICYmIHNtaV9pbmZvLT5jdXJyX21zZyA9PSBOVUxMKSB7DQogCQlzdGFydF9uZXh0X21zZyhzbWlf
aW5mbyk7DQorCQlzbWlfZXZlbnRfaGFuZGxlcihzbWlfaW5mbywgMCk7DQorCX0NCiAJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmc21pX2luZm8tPnNpX2xvY2ssIGZsYWdzKTsNCiB9DQogDQoNCg==

--_002_4ECF88665030601dellcom_--
