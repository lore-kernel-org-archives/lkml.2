Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0HUKyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 06:54:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37732 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0HUKyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 06:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DNXL866AmEjMNX50QglqJ4pw2x0e2uqIyHo/ta+PBTWOEU+87XR4spfo7yBHA4+oov
         iQAy8uQRNXcMoSCR2I9Rj7M9WvBJ6Bgj8BgSbHwOhmmBE0mQQ3CWexwl+n6Q4G/4BDQU
         7vXuUX13wxPNEzE5O43arBwRGEBKRlKrFa8gg=
MIME-Version: 1.0
Date: Sat, 21 Aug 2010 14:54:06 +0400
Message-ID: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
Subject: [PATCH] USB: Fix kernel oops with g_ether and Windows
From: Maxim Osipov <maxim.osipov@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Maxim Osipov <maxim.osipov@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00504502b9acf8e40d048e533ba2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502b9acf8e40d048e533ba2
Content-Type: text/plain; charset=UTF-8

Hello,

Please find attached patch for
https://bugzilla.kernel.org/show_bug.cgi?id=16023 problem.

Kind regards,
Maxim

--00504502b9acf8e40d048e533ba2
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-USB-Fix-kernel-oops-with-g_ether-and-Windows.patch"
Content-Disposition: attachment; 
	filename="0001-USB-Fix-kernel-oops-with-g_ether-and-Windows.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gd4cpqr60

RnJvbSA0MzU2OGRlYzRmMzg3ZGE0NTYyZDViYzgxNTU3YzY0MmE0NjhiNjg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBPc2lwb3YgPG1heGltLm9zaXBvdkBnbWFpbC5jb20+
CkRhdGU6IFRodSwgMTkgQXVnIDIwMTAgMDc6MjU6MjggKzA0MDAKU3ViamVjdDogW1BBVENIXSBV
U0I6IEZpeCBrZXJuZWwgb29wcyB3aXRoIGdfZXRoZXIgYW5kIFdpbmRvd3MKClNpZ25lZC1vZmYt
Ynk6IE1heGltIE9zaXBvdiA8bWF4aW0ub3NpcG92QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL3Vz
Yi9nYWRnZXQvcm5kaXMuYyB8ICAgMTAgKysrKysrKy0tLQogMSBmaWxlcyBjaGFuZ2VkLCA3IGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZ2Fk
Z2V0L3JuZGlzLmMgYi9kcml2ZXJzL3VzYi9nYWRnZXQvcm5kaXMuYwppbmRleCA1YzBkMDZjLi4x
MDQzZGExIDEwMDY0NAotLS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQvcm5kaXMuYworKysgYi9kcml2
ZXJzL3VzYi9nYWRnZXQvcm5kaXMuYwpAQCAtMjkyLDkgKzI5MiwxMyBAQCBnZW5fbmRpc19xdWVy
eV9yZXNwIChpbnQgY29uZmlnTnIsIHUzMiBPSUQsIHU4ICpidWYsIHVuc2lnbmVkIGJ1Zl9sZW4s
CiAJLyogbWFuZGF0b3J5ICovCiAJY2FzZSBPSURfR0VOX1ZFTkRPUl9ERVNDUklQVElPTjoKIAkJ
cHJfZGVidWcoIiVzOiBPSURfR0VOX1ZFTkRPUl9ERVNDUklQVElPTlxuIiwgX19mdW5jX18pOwot
CQlsZW5ndGggPSBzdHJsZW4gKHJuZGlzX3Blcl9kZXZfcGFyYW1zIFtjb25maWdOcl0udmVuZG9y
RGVzY3IpOwotCQltZW1jcHkgKG91dGJ1ZiwKLQkJCXJuZGlzX3Blcl9kZXZfcGFyYW1zIFtjb25m
aWdOcl0udmVuZG9yRGVzY3IsIGxlbmd0aCk7CisJCWlmICggcm5kaXNfcGVyX2Rldl9wYXJhbXMg
W2NvbmZpZ05yXS52ZW5kb3JEZXNjciApIHsKKwkJCWxlbmd0aCA9IHN0cmxlbiAocm5kaXNfcGVy
X2Rldl9wYXJhbXMgW2NvbmZpZ05yXS52ZW5kb3JEZXNjcik7CisJCQltZW1jcHkgKG91dGJ1ZiwK
KwkJCQlybmRpc19wZXJfZGV2X3BhcmFtcyBbY29uZmlnTnJdLnZlbmRvckRlc2NyLCBsZW5ndGgp
OworCQl9IGVsc2UgeworCQkJb3V0YnVmWzBdID0gMDsKKwkJfQogCQlyZXR2YWwgPSAwOwogCQli
cmVhazsKIAotLSAKMS43LjEKCg==
--00504502b9acf8e40d048e533ba2--
