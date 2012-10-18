Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2JRUcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:32:54 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48059 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2JRUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:32:51 -0400
MIME-Version: 1.0
In-Reply-To: <20121018182831.GA30905@srcf.ucam.org>
References: <1343340000-7587-1-git-send-email-mjg@redhat.com>
	<CAA7rmPGL827cgT6hM8h_xhokEbTbTnrptoRekVByM7AcMdRUdw@mail.gmail.com>
	<20121018182831.GA30905@srcf.ucam.org>
Date: Thu, 18 Oct 2012 22:32:50 +0200
Message-ID: <CAA7rmPHSX+nOfQc-rs729g7ibkH5VwvsGkiOLLxX794CAgmYSw@mail.gmail.com>
Subject: Re: [PATCH] efi: Build EFI stub with EFI-appropriate options
From: Daniel Vacek <neelx.g@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8ff1c1467840d204cc5b4a83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1c1467840d204cc5b4a83
Content-Type: text/plain; charset=UTF-8

On Thu, Oct 18, 2012 at 8:28 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Oct 18, 2012 at 08:18:51PM +0200, Daniel Vacek wrote:
>
>> s/CLFAGS/CFLAGS/
>>
>> should go to stable too?
>
> Crap. Yes. Feel free to send that.

--nX

--e89a8ff1c1467840d204cc5b4a83
Content-Type: application/octet-stream; 
	name="0001-efi-fix-typo-in-Makefile.patch"
Content-Disposition: attachment; 
	filename="0001-efi-fix-typo-in-Makefile.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8gbotla0

RnJvbSA1Mzg2NGZlOTMyYWE4N2JlNjJmMWM3MDk0NGMzODZjZmY5YmI5MTMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYW5pZWwgVmFjZWsgPG5lZWx4LmdAZ21haWwuY29tPgpEYXRl
OiBUaHUsIDE4IE9jdCAyMDEyIDIyOjA2OjI2ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gZWZpOiBm
aXggdHlwbyBpbiBNYWtlZmlsZQoKLS0tCiBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvTWFrZWZp
bGUgfCAgICAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvTWFrZWZpbGUgYi9hcmNo
L3g4Ni9ib290L2NvbXByZXNzZWQvTWFrZWZpbGUKaW5kZXggOGE4NDUwMS4uMDU5YTE3ZiAxMDA2
NDQKLS0tIGEvYXJjaC94ODYvYm9vdC9jb21wcmVzc2VkL01ha2VmaWxlCisrKyBiL2FyY2gveDg2
L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZQpAQCAtMjksNyArMjksNyBAQCBWTUxJTlVYX09CSlMg
PSAkKG9iaikvdm1saW51eC5sZHMgJChvYmopL2hlYWRfJChCSVRTKS5vICQob2JqKS9taXNjLm8g
XAogCSQob2JqKS9waWdneS5vCiAKICQob2JqKS9lYm9vdC5vOiBLQlVJTERfQ0ZMQUdTICs9IC1m
c2hvcnQtd2NoYXIgLW1uby1yZWQtem9uZQotJChvYmopL2VmaV9zdHViXyQoQklUUykubzogS0JV
SUxEX0NMRkFHUyArPSAtZnNob3J0LXdjaGFyIC1tbm8tcmVkLXpvbmUKKyQob2JqKS9lZmlfc3R1
Yl8kKEJJVFMpLm86IEtCVUlMRF9DRkxBR1MgKz0gLWZzaG9ydC13Y2hhciAtbW5vLXJlZC16b25l
CiAKIGlmZXEgKCQoQ09ORklHX0VGSV9TVFVCKSwgeSkKIAlWTUxJTlVYX09CSlMgKz0gJChvYmop
L2Vib290Lm8gJChvYmopL2VmaV9zdHViXyQoQklUUykubwotLSAKMS43LjEwLjQKCg==
--e89a8ff1c1467840d204cc5b4a83--
