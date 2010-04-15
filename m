Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0DOOJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:09:37 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:54859 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab0DOOJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:09:36 -0400
To: <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] watchdog/max63xx: be careful when disabling the watchdog
MIME-Version: 1.0
Date: Thu, 15 Apr 2010 16:09:35 +0200
From: Marc Zyngier <maz@misterjones.org>
Organization: Metropolis
Message-ID: <b618a3827c2a4d627640f260cca3c71a@localhost>
User-Agent: RoundCube Webmail/0.3.1
Content-Type: multipart/mixed;
	boundary="=_62b7f2e7b51a0ccd024024f591abfbf5"
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: wim@iguana.be, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=_62b7f2e7b51a0ccd024024f591abfbf5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"

Wim,

The attached patch fixes a nasty error with the max63xx driver,
potentially leaving the platform dead (and watchdog disabled...).

Cheers,

        M.
-- 
Who you jivin' with that Cosmik Debris?
--=_62b7f2e7b51a0ccd024024f591abfbf5
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name*0*="UTF-8''watchdog-max63xx-be-careful-when-disabling-the-watch.pat"
 name*1*="ch";
Content-Disposition: attachment;
 filename*0*="UTF-8''watchdog-max63xx-be-careful-when-disabling-the-watch"
 filename*1*=".patch";

RnJvbSA0MjEyZDg0YTA4ODQ1YTZhZGYzZjY3MzY3YTI0ZDlkYmYwNzZmOWQ2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJjIFp5bmdpZXIgPG1hekBtaXN0ZXJqb25lcy5vcmc+CkRh
dGU6IEZyaSwgOSBBcHIgMjAxMCAxNzo0MzozMyArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHdhdGNo
ZG9nL21heDYzeHg6IGJlIGNhcmVmdWwgd2hlbiBkaXNhYmxpbmcgdGhlIHdhdGNoZG9nCgpXaGVu
IHNodXR0aW5nIGRvd24gdGhlIHdhdGNoZG9nIHRpbWVyLCBzcGVjaWFsIGNhcmUgbXVzdCBiZSB0
YWtlbgpub3QgdG8gb3ZlcndyaXRlIG90aGVyIGJpdHMgaW4gdGhlIHJlZ2lzdGVyLCBhcyBpdCBt
YXkgYmUgc2hhcmVkCndpdGggb3RoZXIgcGVyaXBoZXJhbHMuCgpGb3IgZXhhbXBsZSwgb24gdGhl
IEFyY29tIFZ1bGNhbiwgdGhlIHJlZ2lzdGVyIGlzIHNoYXJlZCBiZXR3ZWVuCnRoZSB3YXRjaGRv
ZyBhbmQgdGhlIFBDSSByZXNldCBsaW5lLi4uCgpTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIg
PG1hekBtaXN0ZXJqb25lcy5vcmc+Ci0tLQogZHJpdmVycy93YXRjaGRvZy9tYXg2M3h4X3dkdC5j
IHwgICAgNyArKysrKystCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3dhdGNoZG9nL21heDYzeHhfd2R0LmMgYi9k
cml2ZXJzL3dhdGNoZG9nL21heDYzeHhfd2R0LmMKaW5kZXggNzVmM2E4My4uMzA1M2ZmMCAxMDA2
NDQKLS0tIGEvZHJpdmVycy93YXRjaGRvZy9tYXg2M3h4X3dkdC5jCisrKyBiL2RyaXZlcnMvd2F0
Y2hkb2cvbWF4NjN4eF93ZHQuYwpAQCAtMTU0LDkgKzE1NCwxNCBAQCBzdGF0aWMgdm9pZCBtYXg2
M3h4X3dkdF9lbmFibGUoc3RydWN0IG1heDYzeHhfdGltZW91dCAqZW50cnkpCiAKIHN0YXRpYyB2
b2lkIG1heDYzeHhfd2R0X2Rpc2FibGUodm9pZCkKIHsKKwl1OCB2YWw7CisKIAlzcGluX2xvY2so
JmlvX2xvY2spOwogCi0JX19yYXdfd3JpdGViKDMsIHdkdF9iYXNlKTsKKwl2YWwgPSBfX3Jhd19y
ZWFkYih3ZHRfYmFzZSk7CisJdmFsICY9IH5NQVg2MzY5X1dEU0VUOworCXZhbCB8PSAzOworCV9f
cmF3X3dyaXRlYih2YWwsIHdkdF9iYXNlKTsKIAogCXNwaW5fdW5sb2NrKCZpb19sb2NrKTsKIAot
LSAKMS43LjAKCg==
--=_62b7f2e7b51a0ccd024024f591abfbf5--

