Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2KPSPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:15:25 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47119 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab2KPSPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <50A661F5.6040301@zytor.com>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
	<1353055989-31939-2-git-send-email-yinghai@kernel.org>
	<50A661F5.6040301@zytor.com>
Date: Fri, 16 Nov 2012 10:15:22 -0800
X-Google-Sender-Auth: GN5iohcHnNjNHf-wi5jxzbV6k3s
Message-ID: <CAE9FiQWdhJHAB0Fjk3_+k-hxF0dYwybMD8RuF=bPL26BosruwA@mail.gmail.com>
Subject: Re: [PATCH 1/9] x86, boot: Move lldt/ltr out of 64bit only path
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: multipart/mixed; boundary=0015174c33d646713504cea0c04d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c33d646713504cea0c04d
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Nov 16, 2012 at 7:55 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/16/2012 12:53 AM, Yinghai Lu wrote:
>>
>> Also it push down startup_64 to 0x208.
>>
>
> NAK.  0x200 is an ABI, you can't change it.
>

ok, will add attached patche before this one and keep 0x200.

Thanks

Yinghai

--0015174c33d646713504cea0c04d
Content-Type: application/octet-stream; name="move_verify_cpu.patch"
Content-Disposition: attachment; filename="move_verify_cpu.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h9lmnmxs0

U3ViamVjdDogW1BBVENIXSB4ODYsIGJvb3Q6IG1vdmUgdmVyaWZ5X2NwdS5TIGFmdGVyIDB4MjAw
CgpXZSBhcmUgc2hvcnQgb2Ygc3BhY2UgYmVmb3JlIDB4MjAwIGZvciBzdGFydHVwXzY0LgoKYmVm
b3JlIHRoYXQgYXJlIDMyIGJpdCBjb2RlLiBXZSBjb3VsZCBtb3ZlIGZ1bmN0aW9uIHZlcmlmeV9j
cHUgZG93bgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoK
LS0tCiBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvaGVhZF82NC5TIHwgICAgNSArKystLQogMSBm
aWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51
eC0yLjYvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL2hlYWRfNjQuUwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC0yLjYub3JpZy9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvaGVhZF82NC5TCisrKyBsaW51
eC0yLjYvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL2hlYWRfNjQuUwpAQCAtMTgyLDggKzE4Miw2
IEBAIG5vX2xvbmdtb2RlOgogCWhsdAogCWptcCAgICAgMWIKIAotI2luY2x1ZGUgIi4uLy4uL2tl
cm5lbC92ZXJpZnlfY3B1LlMiCi0KIAkvKgogCSAqIEJlIGNhcmVmdWwgaGVyZSBzdGFydHVwXzY0
IG5lZWRzIHRvIGJlIGF0IGEgcHJlZGljdGFibGUKIAkgKiBhZGRyZXNzIHNvIEkgY2FuIGV4cG9y
dCBpdCBpbiBhbiBFTEYgaGVhZGVyLiAgQm9vdGxvYWRlcnMKQEAgLTM0OSw2ICszNDcsOSBAQCBy
ZWxvY2F0ZWQ6CiAgKi8KIAlqbXAJKiVyYnAKIAorCS5jb2RlMzIKKyNpbmNsdWRlICIuLi8uLi9r
ZXJuZWwvdmVyaWZ5X2NwdS5TIgorCiAJLmRhdGEKIGdkdDoKIAkud29yZAlnZHRfZW5kIC0gZ2R0
Cg==
--0015174c33d646713504cea0c04d--
