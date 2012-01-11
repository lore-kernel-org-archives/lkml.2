Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2AKJVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:21:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36522 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab2AKJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:21:15 -0500
MIME-Version: 1.0
In-Reply-To: <4F0C75A5.6000000@xenotime.net>
References: <20120109113633.24486.69758.stgit@localhost6.localdomain6>
	<20120109113641.24486.95511.stgit@localhost6.localdomain6>
	<4F0B6845.4080503@xenotime.net>
	<CAPiS6wCVo40tB40sXTzTt7RpVHJG_2wrYeP8L=ghin09WHftfg@mail.gmail.com>
	<4F0C75A5.6000000@xenotime.net>
Date: Wed, 11 Jan 2012 11:21:14 +0200
Message-ID: <CAPiS6wDYrryyPimun2N0xFCY3xCTDAS+tKKAmuZGjbSUjWpZGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] menuconfig: add Home and End keys support for inputbox
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d45feb40c0ee04b63d27a7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d45feb40c0ee04b63d27a7
Content-Type: text/plain; charset=UTF-8

On Tue, Jan 10, 2012 at 7:30 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/10/2012 03:50 AM, Paulius Zaleckas wrote:
>> On Tue, Jan 10, 2012 at 12:20 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>> On 01/09/2012 03:36 AM, Paulius Zaleckas wrote:
>>>> Makes long string editing easier.
>>>>
>>>> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
>>>
>>> Hi,
>>>
>>> Does "default hostname" in the "General setup" menu use an inputbox?
>>
>> Yes, it does.
>>
>>> If so, I can't get Home and End keys to work for it.
>>
>> Strange. It works for me. Have you applied both patches?
>
> Yes, I have both patches applied.

Ok this is really very strange, but I have made debug patch. See attachement.
It will print octal pressed key value just below the text field.

>From curses.h:
#define KEY_HOME	0406		/* home key */
#define KEY_END		0550		/* end key */

Do you get the same values for Home and End keys? I do.

--0016e6d45feb40c0ee04b63d27a7
Content-Type: text/x-diff; charset=US-ASCII; name="inputbox_debug.patch"
Content-Disposition: attachment; filename="inputbox_debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxa50c5m0

RGVidWcgaW5wdXRib3ggYnkgcHJpbnRpbmcgb2N0YWwga2V5IHZhbHVlcy4KCkZyb206IFBhdWxp
dXMgWmFsZWNrYXMgPHBhdWxpdXMuemFsZWNrYXNAZ21haWwuY29tPgoKCi0tLQoKIHNjcmlwdHMv
a2NvbmZpZy9seGRpYWxvZy9pbnB1dGJveC5jIHwgICAxMCArKysrKysrKysrCiAxIGZpbGVzIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgoKZGlmZiAtLWdpdCBhL3Nj
cmlwdHMva2NvbmZpZy9seGRpYWxvZy9pbnB1dGJveC5jIGIvc2NyaXB0cy9rY29uZmlnL2x4ZGlh
bG9nL2lucHV0Ym94LmMKaW5kZXggMGQ5Y2FjYy4uZWNiNzc4YyAxMDA2NDQKLS0tIGEvc2NyaXB0
cy9rY29uZmlnL2x4ZGlhbG9nL2lucHV0Ym94LmMKKysrIGIvc2NyaXB0cy9rY29uZmlnL2x4ZGlh
bG9nL2lucHV0Ym94LmMKQEAgLTExNCw3ICsxMTQsMTcgQEAgZG9fcmVzaXplOgogCXdyZWZyZXNo
KGRpYWxvZyk7CiAKIAl3aGlsZSAoa2V5ICE9IEtFWV9FU0MpIHsKKwkJY2hhciBrZXlfbnVtWzRd
OworCiAJCWtleSA9IHdnZXRjaChkaWFsb2cpOworCQlzbnByaW50ZihrZXlfbnVtLCA0LCAiJTAz
byIsIGtleSk7CisJCXdhdHRyc2V0KGRpYWxvZywgZGxnLmlucHV0Ym94LmF0cik7CisJCXdtb3Zl
KGRpYWxvZywgYm94X3kgKyAyLCBib3hfeCk7CisJCXdhZGRjaChkaWFsb2csIGtleV9udW1bMF0p
OworCQl3YWRkY2goZGlhbG9nLCBrZXlfbnVtWzFdKTsKKwkJd2FkZGNoKGRpYWxvZywga2V5X251
bVsyXSk7CisJCXdtb3ZlKGRpYWxvZywgYm94X3ksIGlucHV0X3ggKyBib3hfeCk7CisJCXdyZWZy
ZXNoKGRpYWxvZyk7CiAKIAkJaWYgKGJ1dHRvbiA9PSAtMSkgewkvKiBJbnB1dCBib3ggc2VsZWN0
ZWQgKi8KIAkJCXN3aXRjaCAoa2V5KSB7Cg==
--0016e6d45feb40c0ee04b63d27a7--
