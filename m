Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2GHSvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 14:51:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2GHSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAK0ehjE6E-4UOBKMDhQtkBD=bvUSgyOmNd-4g+dmTSU4BnpJog@mail.gmail.com>
References: <CAK0ehjE6E-4UOBKMDhQtkBD=bvUSgyOmNd-4g+dmTSU4BnpJog@mail.gmail.com>
Date: Sun, 8 Jul 2012 22:51:12 +0400
Message-ID: <CAK0ehjEeB4a4jE4ym9-7iLQFUAod4qZuF4xtKeOvs1g7jWf6mw@mail.gmail.com>
Subject: [PATCH] Add Razer Onza Tournament Edition to xpad device list
From: K900 <k0009000@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b15b2213246f004c455fbb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b15b2213246f004c455fbb0
Content-Type: text/plain; charset=UTF-8

This adds support for Razer Onza Tournament Edition (
http://store.razerzone.com/store/razerusa/en_US/pd/productID.218524000/categoryId.54297600
) controller to the xpad module. It's very simple, I just added
another entry to the device list, everything works as it should. I'm
not sure if this works with the original Onza (
http://store.razerzone.com/store/razerusa/en_US/pd/productID.218523900/categoryId.54297600
) because I don't have one and it might have a different ID even
though it's pretty much the same hardware.

P.S. To anyone replying to this message (if ever): please CC me,
because I'm too scared to subscribe to linux-kernel for now >.<
P.P.S. Resending because GMail used HTML the first time

--047d7b15b2213246f004c455fbb0
Content-Type: application/octet-stream; name="onza.diff"
Content-Disposition: attachment; filename="onza.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4epjr580

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5wdXQvam95c3RpY2sveHBhZC5jIGIvZHJpdmVycy9pbnB1
dC9qb3lzdGljay94cGFkLmMKaW5kZXggZWUxNmZiNi4uNDhlYTg3ZCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9pbnB1dC9qb3lzdGljay94cGFkLmMKKysrIGIvZHJpdmVycy9pbnB1dC9qb3lzdGljay94
cGFkLmMKQEAgLTE2NCw2ICsxNjQsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHhwYWRfZGV2aWNl
IHsKIAl7IDB4MWJhZCwgMHgwMDAzLCAiSGFybW9uaXggUm9jayBCYW5kIERydW1raXQiLCBNQVBf
RFBBRF9UT19CVVRUT05TLCBYVFlQRV9YQk9YMzYwIH0sCiAJeyAweDBmMGQsIDB4MDAxNiwgIkhv
cmkgUmVhbCBBcmNhZGUgUHJvLkVYIiwgTUFQX1RSSUdHRVJTX1RPX0JVVFRPTlMsIFhUWVBFX1hC
T1gzNjAgfSwKIAl7IDB4MGYwZCwgMHgwMDBkLCAiSG9yaSBGaWdodGluZyBTdGljayBFWDIiLCBN
QVBfVFJJR0dFUlNfVE9fQlVUVE9OUywgWFRZUEVfWEJPWDM2MCB9LAorICAgIHsgMHgxNjg5LCAw
eGZkMDAsICJSYXplciBPbnphIFRvdXJuYW1lbnQgRWRpdGlvbiIsIE1BUF9EUEFEX1RPX0JVVFRP
TlMsIFhUWVBFX1hCT1gzNjAgfSwKIAl7IDB4ZmZmZiwgMHhmZmZmLCAiQ2hpbmVzZS1tYWRlIFhi
b3ggQ29udHJvbGxlciIsIDAsIFhUWVBFX1hCT1ggfSwKIAl7IDB4MDAwMCwgMHgwMDAwLCAiR2Vu
ZXJpYyBYLUJveCBwYWQiLCAwLCBYVFlQRV9VTktOT1dOIH0KIH07CkBAIC0yNDQsNiArMjQ1LDcg
QEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIHhwYWRfdGFibGUgW10gPSB7CiAJWFBBRF9Y
Qk9YMzYwX1ZFTkRPUigweDE0NmIpLAkJLyogQmlnQmVuIEludGVyYWN0aXZlIENvbnRyb2xsZXJz
ICovCiAJWFBBRF9YQk9YMzYwX1ZFTkRPUigweDFiYWQpLAkJLyogSGFybWluaXggUm9jayBCYW5k
IEd1aXRhciBhbmQgRHJ1bXMgKi8KIAlYUEFEX1hCT1gzNjBfVkVORE9SKDB4MGYwZCksICAgICAg
ICAgICAgLyogSG9yaSBDb250cm9sbGVycyAqLworICAgIFhQQURfWEJPWDM2MF9WRU5ET1IoMHgx
Njg5KSwgICAgICAgIC8qIFJhemVyIE9uemEgKi8KIAl7IH0KIH07CiAK
--047d7b15b2213246f004c455fbb0--
