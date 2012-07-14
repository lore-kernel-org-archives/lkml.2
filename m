Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2GNDds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 23:33:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40608 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab2GNDdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 23:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120711044155.GA10438@localhost>
References: <20120706144622.GA13387@localhost>
	<20120706144846.GA13505@localhost>
	<CAPM=9txA0OAm=8ROHXBpXZ+-onqJx41yK4_-v1go8e8W6ROVzw@mail.gmail.com>
	<CAPM=9tzUkUOkA8-RNA4rztUXuKREKYGJVR3=0oYM7ufR9kRacA@mail.gmail.com>
	<20120707020847.GA28771@localhost>
	<20120707153142.GA24787@localhost>
	<20120711044155.GA10438@localhost>
Date: Sat, 14 Jul 2012 13:33:45 +1000
Message-ID: <CAPM=9twZW2DnaeBEvwt5kk0dS85xJUqNHfUdGqXX8io+MTYw5w@mail.gmail.com>
Subject: Re: general protection fault on ttm_init()
From: Dave Airlie <airlied@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f83a6132cc7f704c4c1dd4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f83a6132cc7f704c4c1dd4d
Content-Type: text/plain; charset=ISO-8859-1

Can you try this patch on top of the previous one?

I think it should fix it.

Dave.

--e89a8f83a6132cc7f704c4c1dd4d
Content-Type: application/octet-stream; 
	name="0001-drm-set-drm_class-to-NULL-after-removing-it.patch"
Content-Disposition: attachment; 
	filename="0001-drm-set-drm_class-to-NULL-after-removing-it.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4m54kq00

RnJvbSBiMGE0Y2I0NjA2MjY4M2Q4NzRhZDJiMjIzM2NhZDBkMGJhOGY2ZjMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEBnbWFpbC5jb20+CkRhdGU6
IFNhdCwgMTQgSnVsIDIwMTIgMTM6MzE6MDMgKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm06IHNl
dCBkcm1fY2xhc3MgdG8gTlVMTCBhZnRlciByZW1vdmluZyBpdC4KCldlIG5lZWQgdG8gc2V0IHRo
aXMgdG8gTlVMTCB0byBzdG9wIGxhdGVyIHVzZXJzIGZyb20gdXNpbmcgaXQKYWZ0ZXIgZnJlZS4K
ClJlcG9ydGVkLWJ5OiBGZW5nZ3VhbmcgV3UgPGZlbmdndWFuZy53dUBpbnRlbC5jb20+ClNpZ25l
ZC1vZmYtYnk6IERhdmUgQWlybGllIDxhaXJsaWVkQHJlZGhhdC5jb20+Ci0tLQogZHJpdmVycy9n
cHUvZHJtL2RybV9zeXNmcy5jIHwgICAgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vZHJtX3N5c2ZzLmMgYi9kcml2ZXJzL2dw
dS9kcm0vZHJtX3N5c2ZzLmMKaW5kZXggZGU4YzYzNi4uNDVhYzhkNiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9ncHUvZHJtL2RybV9zeXNmcy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fc3lzZnMu
YwpAQCAtMTM0LDYgKzEzNCw3IEBAIHZvaWQgZHJtX3N5c2ZzX2Rlc3Ryb3kodm9pZCkKIAkJcmV0
dXJuOwogCWNsYXNzX3JlbW92ZV9maWxlKGRybV9jbGFzcywgJmNsYXNzX2F0dHJfdmVyc2lvbi5h
dHRyKTsKIAljbGFzc19kZXN0cm95KGRybV9jbGFzcyk7CisJZHJtX2NsYXNzID0gTlVMTDsKIH0K
IAogLyoqCi0tIAoxLjcuMTAuNAoK
--e89a8f83a6132cc7f704c4c1dd4d--
