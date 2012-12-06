Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946869Ab2LFS54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:57:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43088 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946465Ab2LFS5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:57:53 -0500
MIME-Version: 1.0
In-Reply-To: <20121206185439.GA17381@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
	<CAErSpo6dn_0b8Ngx9VT=ARs_UXQftEx=2Kczeqemtmo0XyKzuQ@mail.gmail.com>
	<20121203200241.GG5906@thinkpad-t410>
	<CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
	<50BFE88D.1000800@zytor.com>
	<CAE9FiQXwZAAMkWYT8EjsewpuZ-OWqoaFscyzGS_pSuO9C3bf9A@mail.gmail.com>
	<CAE9FiQX+aJi5XEyjfjc=K4eXLbQNqE-vd+coyt1dmuujsi_eoQ@mail.gmail.com>
	<CAErSpo7-hUbvvCYPSwtSYKMKWqu99A5H5R4004rSj5Bmv0593g@mail.gmail.com>
	<50C0E339.4030607@zytor.com>
	<20121206185439.GA17381@srcf.ucam.org>
Date: Thu, 6 Dec 2012 10:57:51 -0800
X-Google-Sender-Auth: uLUFzSQDmOnhF7mDMdJrV2Gi-5E
Message-ID: <CAE9FiQWrfp4ptabLiGTv+tH2Nc9i+opX2O9Kk32MbwhF3vCOqg@mail.gmail.com>
Subject: Re: Use PCI ROMs from EFI boot services
From: Yinghai Lu <yinghai@kernel.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: multipart/mixed; boundary=00151747821603b65004d033adfa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151747821603b65004d033adfa
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 6, 2012 at 10:54 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Dec 06, 2012 at 10:26:01AM -0800, H. Peter Anvin wrote:
>
>> NAK on this bit:
>>
>> +       if (boot_params.hdr.version < 0x0209)
>> +               return 0;
>>
>> This field is kernel->bootloader documentation.  If a nonmaching
>> value somehow leaks into the kernel, the kernel could either
>> panic("Bootloader written by moron") or it should clear some fields,
>> but littering the kernel with these kinds of tests is just plain
>> braindead.
>
> Dropping that should be fine. Bjorn, would you prefer a patch from me to
> do that?

the one : use pointer for setup_pci instead.

--00151747821603b65004d033adfa
Content-Type: application/octet-stream; name="pa_data_setup_pci.patch"
Content-Disposition: attachment; filename="pa_data_setup_pci.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hae8zzxq0

U3ViamVjdDogW1BBVENIXSB4ODYsIHBjaTogbW92ZSBib290X3BhcmFtcyBiYWNrIHRvIF9faW5p
dGRhdGEKCkRvbid0IHdhc3RlIDRrIGZvciA4IGJ5dGVzLgoKQWxzbyBJIGRvbid0IHNlZSB0aGUg
cmVhc29uIHdoeSBEVEIgY291bGQgb25seSBoYXZlIG9uZSBlbnRyeQpidXQgU0VUVVBfVVAgZGF0
YSBoYXZlIG11bHRpcGxlLgoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3BjaS5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcGNpLmgKaW5kZXggZGJhNzgwNS4uNTQzNThmOCAxMDA2
NDQKLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcGNpLmgKKysrIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20vcGNpLmgKQEAgLTE4Myw0ICsxODMsNiBAQCBzdHJ1Y3QgcGNpX3NldHVwX3JvbSB7CiAJ
dWludDhfdCByb21kYXRhWzBdOwogfTsKIAorZXh0ZXJuIHU2NCBwYV9kYXRhX3NldHVwX3BjaTsK
KwogI2VuZGlmIC8qIF9BU01fWDg2X1BDSV9IICovCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJu
ZWwvc2V0dXAuYyBiL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCmluZGV4IDJiZDQwZmQuLjgwNjJm
MjUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCisrKyBiL2FyY2gveDg2L2tl
cm5lbC9zZXR1cC5jCkBAIC0xNDMsNyArMTQzLDExIEBAIGludCBkZWZhdWx0X2NoZWNrX3BoeXNf
YXBpY2lkX3ByZXNlbnQoaW50IHBoeXNfYXBpY2lkKQogfQogI2VuZGlmCiAKKyNpZm5kZWYgQ09O
RklHX0RFQlVHX0JPT1RfUEFSQU1TCitzdHJ1Y3QgYm9vdF9wYXJhbXMgX19pbml0ZGF0YSBib290
X3BhcmFtczsKKyNlbHNlCiBzdHJ1Y3QgYm9vdF9wYXJhbXMgYm9vdF9wYXJhbXM7CisjZW5kaWYK
IAogLyoKICAqIE1hY2hpbmUgc2V0dXAuLgpAQCAtNDE0LDYgKzQxOCw4IEBAIHN0YXRpYyB2b2lk
IF9faW5pdCByZXNlcnZlX2luaXRyZCh2b2lkKQogfQogI2VuZGlmIC8qIENPTkZJR19CTEtfREVW
X0lOSVRSRCAqLwogCit1NjQgcGFfZGF0YV9zZXR1cF9wY2k7CisKIHN0YXRpYyB2b2lkIF9faW5p
dCBwYXJzZV9zZXR1cF9kYXRhKHZvaWQpCiB7CiAJc3RydWN0IHNldHVwX2RhdGEgKmRhdGE7CkBA
IC00NDIsNiArNDQ4LDEwIEBAIHN0YXRpYyB2b2lkIF9faW5pdCBwYXJzZV9zZXR1cF9kYXRhKHZv
aWQpCiAJCWNhc2UgU0VUVVBfRFRCOgogCQkJYWRkX2R0YihwYV9kYXRhKTsKIAkJCWJyZWFrOwor
CQljYXNlIFNFVFVQX1BDSToKKwkJCWlmICghc2V0dXBfZGF0YV9wY2kpCisJCQkJcGFfZGF0YV9z
ZXR1cF9wY2kgPSBwYV9kYXRhOworCQkJYnJlYWs7CiAJCWRlZmF1bHQ6CiAJCQlicmVhazsKIAkJ
fQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvcGNpL2NvbW1vbi5jIGIvYXJjaC94ODYvcGNpL2NvbW1v
bi5jCmluZGV4IDQ3NTg0ZjQuLjRlMTY2NTEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3BjaS9jb21t
b24uYworKysgYi9hcmNoL3g4Ni9wY2kvY29tbW9uLmMKQEAgLTYxMywxMiArNjEzLDggQEAgaW50
IHBjaWJpb3NfYWRkX2RldmljZShzdHJ1Y3QgcGNpX2RldiAqZGV2KQogewogCXN0cnVjdCBzZXR1
cF9kYXRhICpkYXRhOwogCXN0cnVjdCBwY2lfc2V0dXBfcm9tICpyb207Ci0JdTY0IHBhX2RhdGE7
CisJdTY0IHBhX2RhdGEgPSBwYV9kYXRhX3NldHVwX3BjaTsKIAotCWlmIChib290X3BhcmFtcy5o
ZHIudmVyc2lvbiA8IDB4MDIwOSkKLQkJcmV0dXJuIDA7Ci0KLQlwYV9kYXRhID0gYm9vdF9wYXJh
bXMuaGRyLnNldHVwX2RhdGE7CiAJd2hpbGUgKHBhX2RhdGEpIHsKIAkJZGF0YSA9IHBoeXNfdG9f
dmlydChwYV9kYXRhKTsKIAo=
--00151747821603b65004d033adfa--
