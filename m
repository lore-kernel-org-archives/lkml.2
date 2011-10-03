Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1JCXdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:33:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1JCXdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:33:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110031415110.31654@pobox.suse.cz>
References: <1317452093-25555-1-git-send-email-iwamatsu@nigauri.org>
 <alpine.LNX.2.00.1110031402360.31654@pobox.suse.cz> <alpine.LNX.2.00.1110031415110.31654@pobox.suse.cz>
From: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Date: Tue, 4 Oct 2011 08:33:18 +0900
Message-ID: <CABMQnV+y+yw-cY9CexT_eVWqsJFkT0ffZLx87y5CRuX=KiOtpQ@mail.gmail.com>
Subject: Re: [PATCH] HID: Add support MacbookAir 4,1 keyboard
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, "Joshua V. Dillon" <jvdillon@gmail.com>
Content-Type: multipart/mixed; boundary=0015173ff1ee9ddd7904ae6d67b2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015173ff1ee9ddd7904ae6d67b2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

2011/10/3 Jiri Kosina <jkosina@suse.cz>:
> On Mon, 3 Oct 2011, Jiri Kosina wrote:
>
>> > Added USB device IDs and keyboard map for MacBookAir 4,1 keyboard.
>> >
>> > Signed-off-by: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
>>
>> Applied, thank you.
>
Thanks.

> Oh, and don't we BTW need the hid_mouse_ignore_list[] addition as well? I=
s
> the respective mouse being handled properly by appletouch driver?

I don't work touchpad on MacbookAir yet.
But I think that the change is necessary when I show a past change.
And I think that I am necessary for MacbookAir 4,2.
I made patches, and I attached.

Best regards,
  Nobuhiro

--=20
Nobuhiro Iwamatsu
=A0=A0 iwamatsu at {nigauri.org / debian.org}
=A0=A0 GPG ID: 40AD1FA6

--0015173ff1ee9ddd7904ae6d67b2
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-HID-Add-MacbookAir4-2-to-hid_mouse_ignore_list.patch"
Content-Disposition: attachment; 
	filename="0001-HID-Add-MacbookAir4-2-to-hid_mouse_ignore_list.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtc3ixpu0

RnJvbSBlODJhOWJkNzYxYzg1N2EyZTZjMTg1YzBiYWI4ODk0YjE5N2RmZTkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOb2J1aGlybyBJd2FtYXRzdSA8aXdhbWF0c3VAbmlnYXVyaS5v
cmc+CkRhdGU6IFR1ZSwgNCBPY3QgMjAxMSAwMzo0Mjo1OSArMDkwMApTdWJqZWN0OiBbUEFUQ0gg
MS8yXSBISUQ6IEFkZCBNYWNib29rQWlyNCwyIHRvIGhpZF9tb3VzZV9pZ25vcmVfbGlzdAoKTWFj
Ym9va0FpcjQsMiB1c2VzIGJjbTU5NzQgZHJpdmVyIGZvciB0b3VjaHBhZC4KClNpZ25lZC1vZmYt
Ynk6IE5vYnVoaXJvIEl3YW1hdHN1IDxpd2FtYXRzdUBuaWdhdXJpLm9yZz4KLS0tCiBkcml2ZXJz
L2hpZC9oaWQtY29yZS5jIHwgICAgMyArKysKIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZC1jb3JlLmMg
Yi9kcml2ZXJzL2hpZC9oaWQtY29yZS5jCmluZGV4IDQxNjNjODguLjlmYzE2YmUgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvaGlkL2hpZC1jb3JlLmMKKysrIGIvZHJpdmVycy9oaWQvaGlkLWNvcmUuYwpA
QCAtMTkzOCw2ICsxOTM4LDkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBoaWRfZGV2aWNlX2lkIGhp
ZF9tb3VzZV9pZ25vcmVfbGlzdFtdID0gewogCXsgSElEX1VTQl9ERVZJQ0UoVVNCX1ZFTkRPUl9J
RF9BUFBMRSwgVVNCX0RFVklDRV9JRF9BUFBMRV9XRUxMU1BSSU5HNV9BTlNJKSB9LAogCXsgSElE
X1VTQl9ERVZJQ0UoVVNCX1ZFTkRPUl9JRF9BUFBMRSwgVVNCX0RFVklDRV9JRF9BUFBMRV9XRUxM
U1BSSU5HNV9JU08pIH0sCiAJeyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0FQUExFLCBV
U0JfREVWSUNFX0lEX0FQUExFX1dFTExTUFJJTkc1X0pJUykgfSwKKwl7IEhJRF9VU0JfREVWSUNF
KFVTQl9WRU5ET1JfSURfQVBQTEUsIFVTQl9ERVZJQ0VfSURfQVBQTEVfV0VMTFNQUklORzZfQU5T
SSkgfSwKKwl7IEhJRF9VU0JfREVWSUNFKFVTQl9WRU5ET1JfSURfQVBQTEUsIFVTQl9ERVZJQ0Vf
SURfQVBQTEVfV0VMTFNQUklORzZfSVNPKSB9LAorCXsgSElEX1VTQl9ERVZJQ0UoVVNCX1ZFTkRP
Ul9JRF9BUFBMRSwgVVNCX0RFVklDRV9JRF9BUFBMRV9XRUxMU1BSSU5HNl9KSVMpIH0sCiAJeyBI
SURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0FQUExFLCBVU0JfREVWSUNFX0lEX0FQUExFX0ZP
VU5UQUlOX1RQX09OTFkpIH0sCiAJeyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0FQUExF
LCBVU0JfREVWSUNFX0lEX0FQUExFX0dFWVNFUjFfVFBfT05MWSkgfSwKIAl7IH0KLS0gCjEuNy42
LjMKCg==
--0015173ff1ee9ddd7904ae6d67b2
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0002-HID-Add-MacbookAir4-1-to-hid_mouse_ignore_list.patch"
Content-Disposition: attachment; 
	filename="0002-HID-Add-MacbookAir4-1-to-hid_mouse_ignore_list.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtc3j3r61

RnJvbSA3ZDU2YjAyM2M4ZjUyYjIzNGEyYzk4ZTYwMDE0OWMwNjY2ZjdhNWZkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOb2J1aGlybyBJd2FtYXRzdSA8aXdhbWF0c3VAbmlnYXVyaS5v
cmc+CkRhdGU6IFR1ZSwgNCBPY3QgMjAxMSAwMzo0NDowNyArMDkwMApTdWJqZWN0OiBbUEFUQ0gg
Mi8yXSBISUQ6IEFkZCBNYWNib29rQWlyNCwxIHRvIGhpZF9tb3VzZV9pZ25vcmVfbGlzdAoKTWFj
Ym9va0FpcjQsMSB1c2VzIGJjbTU5NzQgZHJpdmVyIGZvciB0b3VjaHBhZC4KClNpZ25lZC1vZmYt
Ynk6IE5vYnVoaXJvIEl3YW1hdHN1IDxpd2FtYXRzdUBuaWdhdXJpLm9yZz4KLS0tCiBkcml2ZXJz
L2hpZC9oaWQtY29yZS5jIHwgICAgMyArKysKIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaGlkL2hpZC1jb3JlLmMg
Yi9kcml2ZXJzL2hpZC9oaWQtY29yZS5jCmluZGV4IDlmYzE2YmUuLjllY2FkZjUgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvaGlkL2hpZC1jb3JlLmMKKysrIGIvZHJpdmVycy9oaWQvaGlkLWNvcmUuYwpA
QCAtMTk0MSw2ICsxOTQxLDkgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBoaWRfZGV2aWNlX2lkIGhp
ZF9tb3VzZV9pZ25vcmVfbGlzdFtdID0gewogCXsgSElEX1VTQl9ERVZJQ0UoVVNCX1ZFTkRPUl9J
RF9BUFBMRSwgVVNCX0RFVklDRV9JRF9BUFBMRV9XRUxMU1BSSU5HNl9BTlNJKSB9LAogCXsgSElE
X1VTQl9ERVZJQ0UoVVNCX1ZFTkRPUl9JRF9BUFBMRSwgVVNCX0RFVklDRV9JRF9BUFBMRV9XRUxM
U1BSSU5HNl9JU08pIH0sCiAJeyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0FQUExFLCBV
U0JfREVWSUNFX0lEX0FQUExFX1dFTExTUFJJTkc2X0pJUykgfSwKKwl7IEhJRF9VU0JfREVWSUNF
KFVTQl9WRU5ET1JfSURfQVBQTEUsIFVTQl9ERVZJQ0VfSURfQVBQTEVfV0VMTFNQUklORzZBX0FO
U0kpIH0sCisJeyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0FQUExFLCBVU0JfREVWSUNF
X0lEX0FQUExFX1dFTExTUFJJTkc2QV9JU08pIH0sCisJeyBISURfVVNCX0RFVklDRShVU0JfVkVO
RE9SX0lEX0FQUExFLCBVU0JfREVWSUNFX0lEX0FQUExFX1dFTExTUFJJTkc2QV9KSVMpIH0sCiAJ
eyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0FQUExFLCBVU0JfREVWSUNFX0lEX0FQUExF
X0ZPVU5UQUlOX1RQX09OTFkpIH0sCiAJeyBISURfVVNCX0RFVklDRShVU0JfVkVORE9SX0lEX0FQ
UExFLCBVU0JfREVWSUNFX0lEX0FQUExFX0dFWVNFUjFfVFBfT05MWSkgfSwKIAl7IH0KLS0gCjEu
Ny42LjMKCg==
--0015173ff1ee9ddd7904ae6d67b2--
