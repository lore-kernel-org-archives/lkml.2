Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2IVOLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 10:11:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62654 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2IVOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 10:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120922081009.GA5677@localhost>
References: <20120922003557.GF5959@localhost>
	<CAE9FiQVQJQfBZn7AH4M5hibx=iNa9RbfSaBdb35FWxDiRXHvrA@mail.gmail.com>
	<CAE9FiQVQMVsqG2vHhyktTtUSJ_dDRpTpwB_x--agMWbm6PHsEg@mail.gmail.com>
	<20120922081009.GA5677@localhost>
Date: Sat, 22 Sep 2012 07:11:34 -0700
X-Google-Sender-Auth: aNqrgXnCby3-wuqjbuag_M6FSmU
Message-ID: <CAE9FiQWi46m4rP9chVK0W5ahtgk7cuCO60dTYzP6JVM=x=5abA@mail.gmail.com>
Subject: Re: [ACPI/PCI] possible recursive locking detected
From: Yinghai Lu <yinghai@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec555517a1d060c04ca4aef10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec555517a1d060c04ca4aef10
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Sep 22, 2012 at 1:10 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
>> > Please check attached patch that should fix the problem.
>>
>> updated more aggressive version. two patches.
>
> Yes they work nicely. Thank you very much!

Thanks.

v2 breaks acpi_bind_one.

So we should use attached -v3.

Bjorn, please apply -v3 before Taku's patchset.

-Yinghai

--bcaec555517a1d060c04ca4aef10
Content-Type: application/octet-stream; 
	name="pci_root_bus_to_handle_v3.patch"
Content-Disposition: attachment; filename="pci_root_bus_to_handle_v3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7esqp4k0

U3ViamVjdDogW1BBVENIIC12M10gUENJLCBBQ1BJOiBVc2UgREVWSUNFX0FDUElfSEFORExFIGZv
ciByb290IGJ1cyBzdHJ1Y3QgcG9pbnRlcgoKU28gd2UgY291bGQgYXZvaWQgY2FsbGluZyBhY3Bp
X2dldF9wY2lfcm9vdGJyaWRnZV9oYW5kbGUgdGhhdCBjb3VsZCBjYXVzZSBkZWFkbG9jay4KCm5v
biByb290IHBjaSBidXMgaXMgdXNpbmcgYnJpZGdlLT5kZXYgYXJjaGRhdGEuYWNwaV9oYW5kbGUu
CndlIHNob3VkbCB1c2UgdGhhdCBzYW1lIGZpZWxkIGZvciBmb3Igcm9vdCBidXMKCi12MzogZG8g
bm90IG5lZWQgdG8gYW5kICBzaG91bGQgbm90IHNldCB0aGF0IGFyY2hkYXRhLmFjcGlfaGFuZGxl
IGRpcmVjdGx5CiAgICAgYWNwaV9wY2lfcm9vdF9hZGQKCT09PiBwY2lfYWNwaV9zY2FuX3Jvb3QK
CQk9PT4gcGNpX2NyZWF0ZV9yb290X2J1cwoJCQk9PT4gZGV2aWNlX3JlZ2lzdGVyKCZicmlkZ2Ut
PmRldikKCQkJCT09PiBkZXZpY2VfYWRkCgkJCQkJPT0+IHBsYXRmb3JtX25vdGlmeQoJCQkJCQk9
PT4gYWNwaV9iaW5kX29uZQogICAgIHdpbGwgc2V0IHRoYXQgZm9yIHVzLgoJdGhhdCBtZWFuJ3Mg
d2Ugc3RpbGwgbmVlZCB0byBrZWVwIGFjcGlfZ2V0X3BjaV9yb290YnJpZGdlX2hhbmRsZSBmb3IK
CWFjcGlfcGNpX2ZpbmRfcm9vdF9icmlkZ2UgaW4gYWNwaV9wY2lfYnVzIGJ1c190eXBlLgoKU2ln
bmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgpDYzogTGVuIEJyb3du
IDxsZW5iQGtlcm5lbC5vcmc+CkNjOiBsaW51eC1hY3BpQHZnZXIua2VybmVsLm9yZwoKLS0tCiBp
bmNsdWRlL2xpbnV4L3BjaS1hY3BpLmggfCAgIDE1ICsrKysrKysrKystLS0tLQogMSBmaWxlIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42
L2luY2x1ZGUvbGludXgvcGNpLWFjcGkuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9p
bmNsdWRlL2xpbnV4L3BjaS1hY3BpLmgKKysrIGxpbnV4LTIuNi9pbmNsdWRlL2xpbnV4L3BjaS1h
Y3BpLmgKQEAgLTIyLDE5ICsyMiwyNCBAQCBleHRlcm4gcGh5c19hZGRyX3QgYWNwaV9wY2lfcm9v
dF9nZXRfbWNmCiBzdGF0aWMgaW5saW5lIGFjcGlfaGFuZGxlIGFjcGlfZmluZF9yb290X2JyaWRn
ZV9oYW5kbGUoc3RydWN0IHBjaV9kZXYgKnBkZXYpCiB7CiAJc3RydWN0IHBjaV9idXMgKnBidXMg
PSBwZGV2LT5idXM7CisKIAkvKiBGaW5kIGEgUENJIHJvb3QgYnVzICovCiAJd2hpbGUgKCFwY2lf
aXNfcm9vdF9idXMocGJ1cykpCiAJCXBidXMgPSBwYnVzLT5wYXJlbnQ7Ci0JcmV0dXJuIGFjcGlf
Z2V0X3BjaV9yb290YnJpZGdlX2hhbmRsZShwY2lfZG9tYWluX25yKHBidXMpLAotCQkJCQkgICAg
ICBwYnVzLT5udW1iZXIpOworCisJcmV0dXJuIERFVklDRV9BQ1BJX0hBTkRMRShwYnVzLT5icmlk
Z2UpOwogfQogCiBzdGF0aWMgaW5saW5lIGFjcGlfaGFuZGxlIGFjcGlfcGNpX2dldF9icmlkZ2Vf
aGFuZGxlKHN0cnVjdCBwY2lfYnVzICpwYnVzKQogeworCXN0cnVjdCBkZXZpY2UgKmRldjsKKwog
CWlmICghcGNpX2lzX3Jvb3RfYnVzKHBidXMpKQotCQlyZXR1cm4gREVWSUNFX0FDUElfSEFORExF
KCYocGJ1cy0+c2VsZi0+ZGV2KSk7Ci0JcmV0dXJuIGFjcGlfZ2V0X3BjaV9yb290YnJpZGdlX2hh
bmRsZShwY2lfZG9tYWluX25yKHBidXMpLAotCQkJCQkgICAgICBwYnVzLT5udW1iZXIpOworCQlk
ZXYgPSAmcGJ1cy0+c2VsZi0+ZGV2OworCWVsc2UKKwkJZGV2ID0gcGJ1cy0+YnJpZGdlOworCisJ
cmV0dXJuIERFVklDRV9BQ1BJX0hBTkRMRShkZXYpOwogfQogI2VuZGlmCiAK
--bcaec555517a1d060c04ca4aef10--
