Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0LPLq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 06:46:27 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45534 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0LPLqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 06:46:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=s4dusdbi3B7UxpNVxIKz2yJ/DP81sdeAHehd7IHecCUqkydsGUFGhpgRdGKihw2RHJ
         hzJD/0u45tD1Oaj6QwD5gRsa6yRbjVf1kuqsHRYZ+dARsKA9l1s8V79IeNE0DQP3majD
         a+M3/TjqC097F4MjRL8ycM83AHuo7oE4/K6Rs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 16 Dec 2010 12:46:23 +0100
Message-ID: <AANLkTink67RM4mp537UxFcx4g-9Dx+ymbW0A=cCu3C4g@mail.gmail.com>
Subject: [PATCH] iwlwifi: Fix error: struct iwl_lq_sta has no member named dbg_fixed_rate
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        John Linville <linville@tuxdriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: multipart/mixed; boundary=000e0ce0da0a63b4e70497859a4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0ce0da0a63b4e70497859a4c
Content-Type: text/plain; charset=UTF-8

Attached patch fixes an issue with linux-next (20101216) and iwlwifi (see [1]).

- Sedat -

[1] http://lkml.org/lkml/2010/12/16/101

--000e0ce0da0a63b4e70497859a4c
Content-Type: text/plain; charset=UTF-8; 
	name="0001-iwlwifi-Fix-error-struct-iwl_lq_sta-has-no-member-na.patch"
Content-Disposition: attachment; 
	filename="0001-iwlwifi-Fix-error-struct-iwl_lq_sta-has-no-member-na.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghrl3q8y0

RnJvbSA3ZWRmY2I5MjE1OWYzNmNiNmFhYTdlYjFhOTQ1M2Y3NWQ3NDYxMDI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDE2IERlYyAyMDEwIDEyOjI2OjA0ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gaXds
d2lmaTogRml4IGVycm9yOiBzdHJ1Y3QgaXdsX2xxX3N0YSBoYXMgbm8gbWVtYmVyIG5hbWVkIGRi
Z19maXhlZF9yYXRlCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsg
Y2hhcnNldD1VVEYtOApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0CgpXaGlsZSBjb21w
aWxpbmcgbGludXgtbmV4dCAobmV4dC0yMDEwMTIxNikgSSBmZWxsIG92ZXIgdGhpcyBicmVha2Fn
ZToKLi4uCmRyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1ycy5jOiBJbiBmdW5j
dGlvbiDigJhpd2xfcnNfcmF0ZV9pbml04oCZOgpkcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZp
L2l3bC1hZ24tcnMuYzoyODc2Ojg6IGVycm9yOiDigJhzdHJ1Y3QgaXdsX2xxX3N0YeKAmSBoYXMg
bm8gbWVtYmVyIG5hbWVkIOKAmGRiZ19maXhlZF9yYXRl4oCZCgpkYmdfZml4ZWRfcmF0ZSBpcyBv
bmx5IHVzZWQgd2hlbiBDT05GSUdfTUFDODAyMTFfREVCVUdGUyBpcyBzZXQ6CgpbIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1ycy5oIF0KLi4uCiAjaWZkZWYgQ09ORklHX01B
QzgwMjExX0RFQlVHRlMKICAgICAgIHN0cnVjdCBkZW50cnkgKnJzX3N0YV9kYmdmc19zY2FsZV90
YWJsZV9maWxlOwogICAgICAgc3RydWN0IGRlbnRyeSAqcnNfc3RhX2RiZ2ZzX3N0YXRzX3RhYmxl
X2ZpbGU7CiAgICAgICBzdHJ1Y3QgZGVudHJ5ICpyc19zdGFfZGJnZnNfcmF0ZV9zY2FsZV9kYXRh
X2ZpbGU7CiAgICAgICBzdHJ1Y3QgZGVudHJ5ICpyc19zdGFfZGJnZnNfdHhfYWdnX3RpZF9lbl9m
aWxlOwogICAgICAgdTMyIGRiZ19maXhlZF9yYXRlOwogI2VuZGlmCgpUaGUgaXNzdWUgd2FzIGlu
dHJvZHVjZWQgYnkgY29tbWl0IGExZGEwNzdiYzM2MzY4ZWI3ZDYzMTJlN2U0OTI2MGYwYTNkOTJj
Nzc6CiJpd2x3aWZpOiBjbGVhciBkYmdfZml4ZWRfcmF0ZSBkdXJpbmcgaW5pdCIKClNpZ25lZC1v
ZmYtYnk6IFNlZGF0IERpbGVrIDxzZWRhdC5kaWxla0BnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXJzLmMgfCAgICAyICsrCiAxIGZpbGVzIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC1hZ24tcnMuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2l3bHdpZmkvaXdsLWFnbi1ycy5jCmluZGV4IDUwODNkYmEuLjc1ZmNkMzAgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1ycy5jCisrKyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi1ycy5jCkBAIC0yODczLDcgKzI4NzMsOSBAQCB2
b2lkIGl3bF9yc19yYXRlX2luaXQoc3RydWN0IGl3bF9wcml2ICpwcml2LCBzdHJ1Y3QgaWVlZTgw
MjExX3N0YSAqc3RhLCB1OCBzdGFfaQogCQlscV9zdGEtPmxhc3RfdHhyYXRlX2lkeCArPSBJV0xf
RklSU1RfT0ZETV9SQVRFOwogCWxxX3N0YS0+aXNfYWdnID0gMDsKIAorI2lmZGVmIENPTkZJR19N
QUM4MDIxMV9ERUJVR0ZTCiAJbHFfc3RhLT5kYmdfZml4ZWRfcmF0ZSA9IDA7CisjZW5kaWYKIAog
CXJzX2luaXRpYWxpemVfbHEocHJpdiwgY29uZiwgc3RhLCBscV9zdGEpOwogfQotLSAKMS43LjIu
MwoK
--000e0ce0da0a63b4e70497859a4c--
