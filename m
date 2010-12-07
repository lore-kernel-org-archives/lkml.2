Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0LGVzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:55:40 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49006 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0LGVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=ZllIfx/5g6AiuQo/FzQKNOX/07h2GI4m3mzpVOFLm+/n0mMW2RnOko1cWTA0MQ/feD
         9nVKVwQ/eJm0Lb86o4AZ1fk+cl5xTTui3KuW3ra8a3UiTnUPAVhjcrpi9nADFQEhz0f1
         tKUD7FuoDkNN3MI818zJIEKIBJiUZypZNNlGU=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 7 Dec 2010 22:55:38 +0100
Message-ID: <AANLkTimhXLc-YkgPg9So71eOeOtDupnkGyZCEzvK6si3@mail.gmail.com>
Subject: [PATCH] ath5k: Fix modinfo does not list alias -> pci-id lines
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>,
        John Linville <linville@tuxdriver.com>,
        Nick Kossifidis <mickflemm@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ath5k-devel <ath5k-devel@venema.h4ckr.net>,
        Bruno Randolf <br1@einfach.org>
Content-Type: multipart/mixed; boundary=0016363b7f62acd7150496d9102c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363b7f62acd7150496d9102c
Content-Type: text/plain; charset=UTF-8

This patch fixes an issue in wirless-next-2.6 / linux-next
(next-20101207) with ath5k and wrong modinfo output.

- Sedat -

--0016363b7f62acd7150496d9102c
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-ath5k-Fix-modinfo-does-not-list-alias-pci-id-lines.patch"
Content-Disposition: attachment; 
	filename="0001-ath5k-Fix-modinfo-does-not-list-alias-pci-id-lines.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghfbup610

RnJvbSAzOTRjM2NhNGZkYzBlOGU5MmQ4MTE3YzFkYTJlZmRjOTE3MzYyYzUyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDcgRGVjIDIwMTAgMjI6MzU6NTAgKzAxMDAKU3ViamVjdDogW1BBVENIXSBhdGg1
azogRml4IG1vZGluZm8gZG9lcyBub3QgbGlzdCBhbGlhcyAtPiBwY2ktaWQgbGluZXMKClRoZSBB
SEIgYnVzIHN1cHBvcnQgcGF0Y2hzZXQgbW92ZWQgdGhlIHRhYmxlICJLbm93biBQQ0kgaWRzIiBm
cm9tIGJhc2UuYwp0byBwY2kuYyAtIHVuZm9ydHVuYXRlbHksIE1PRFVMRV9ERVZJQ0VfVEFCTEUo
KSB3YXMgbm90IHRyYW5zZmVycmVkLgpXaXRoIHRoaXMgZml4ICdtb2RpbmZvIGF0aDVrJyBsaXN0
cyB0aGUgYWxpYXMgLT4gcGNpLWlkIGxpbmVzLCBhZ2Fpbi4KClRoZSBpc3N1ZSB3YXMgaW50cm9k
dWNlZCBieToKICAgY29tbWl0IGU1YjA0NmQ4NmZhYzYwOWY2MzZkMTI3YTM4ZGU5NGExNzVjN2U4
M2IKICAgImF0aDVrOiBNb3ZlIFBDSSBidXMgZnVuY3Rpb25zIHRvIHNlcGFyYXRlIGZpbGUuIgot
LS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9wY2kuYyB8ICAgIDEgKwogMSBmaWxl
cyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDVrL3BjaS5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDVrL3BjaS5jCmluZGV4IDM5ZjAzMzEuLjdmOGM1YjAgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9wY2kuYworKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvYXRoNWsvcGNpLmMKQEAgLTQ1LDYgKzQ1LDcgQEAgc3RhdGljIERFRklORV9QQ0lf
REVWSUNFX1RBQkxFKGF0aDVrX3BjaV9pZF90YWJsZSkgPSB7CiAJeyBQQ0lfVkRFVklDRShBVEhF
Uk9TLCAweDAwMWQpIH0sIC8qIDI0MTcgTmFsYSAqLwogCXsgMCB9CiB9OworTU9EVUxFX0RFVklD
RV9UQUJMRShwY2ksIGF0aDVrX3BjaV9pZF90YWJsZSk7CiAKIC8qIHJldHVybiBidXMgY2FjaGVz
aXplIGluIDRCIHdvcmQgdW5pdHMgKi8KIHN0YXRpYyB2b2lkIGF0aDVrX3BjaV9yZWFkX2NhY2hl
c2l6ZShzdHJ1Y3QgYXRoX2NvbW1vbiAqY29tbW9uLCBpbnQgKmNzeikKLS0gCjEuNy4yLjMKCg==
--0016363b7f62acd7150496d9102c--
