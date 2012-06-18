Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab2FRXkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:40:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47258 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2FRXkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
	<CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
	<CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
	<CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
Date: Mon, 18 Jun 2012 16:40:42 -0700
X-Google-Sender-Auth: sU8eWLFsX6CSbLEMgHeqFEpmP3E
Message-ID: <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
Subject: Re: SNB PCI root information
From: Yinghai Lu <yinghai@kernel.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: multipart/mixed; boundary=047d7b15ae45c3493c04c2c7b1a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b15ae45c3493c04c2c7b1a1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 18, 2012 at 3:30 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Sat, Jun 16, 2012 at 5:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrot=
e:
>> If ACPI provides a perfectly usable generic way to describe this
>> topology and the vendor BIOS doesn't bother to use it, I'm not very
>> interested in trying to compensate for that BIOS deficiency by adding
>> a bunch of non-portable CPU-specific gunk to Linux.
>
> The problem is that all machines get this wrong. =A0I've tested varies
> models from Dell and HP and none of them have the _PXM entry and the
> local_cpus fields are wrong. =A0If there is a reasonably sane way to
> compensate for broken BIOSes it should be considered. =A0We all know how
> good BIOS authors are...

please check attached one. and  you may append "pci=3Dbusnum_node=3D00:00,8=
0:01"
to change node for root bus.
assume you have two root bus: 00, 80

Thanks

Yinghai

--047d7b15ae45c3493c04c2c7b1a1
Content-Type: application/octet-stream; name="busnum_node.patch"
Content-Disposition: attachment; filename="busnum_node.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3m6q1e00

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24va2VybmVsLXBhcmFtZXRlcnMudHh0IGIvRG9jdW1l
bnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQKaW5kZXggYTkyYzVlYi4uYTY2NDg1ZiAxMDA2
NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQKKysrIGIvRG9jdW1l
bnRhdGlvbi9rZXJuZWwtcGFyYW1ldGVycy50eHQKQEAgLTIxOTAsNiArMjE5MCwxMCBAQCBieXRl
cyByZXNwZWN0aXZlbHkuIFN1Y2ggbGV0dGVyIHN1ZmZpeGVzIGNhbiBhbHNvIGJlIGVudGlyZWx5
IG9taXR0ZWQuCiAJCQkJb2ZmOiBUdXJuIHJlYWxsb2Mgb2ZmCiAJCQkJb246IFR1cm4gcmVhbGxv
YyBvbgogCQlyZWFsbG9jCQlzYW1lIGFzIHJlYWxsb2M9b24KKwkJYnVzbnVtX25vZGU9CisJCQkJ
Rm9ybWF0OgorCQkJCTxidXM+Ojxub2RlPlssIC4uLl0KKwkJCQlTcGVjaWZpZXMgbm9kZSBmb3Ig
YnVzCiAJCW5vYXJpCQlkbyBub3QgdXNlIFBDSWUgQVJJLgogCQlwY2llX3NjYW5fYWxsCVNjYW4g
YWxsIHBvc3NpYmxlIFBDSWUgZGV2aWNlcy4gIE90aGVyd2lzZSB3ZQogCQkJCW9ubHkgbG9vayBm
b3Igb25lIGRldmljZSBiZWxvdyBhIFBDSWUgZG93bnN0cmVhbQpkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvcGNpL2NvbW1vbi5jIGIvYXJjaC94ODYvcGNpL2NvbW1vbi5jCmluZGV4IDBhZDk5MGEuLmE2
NTI3ZmUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L3BjaS9jb21tb24uYworKysgYi9hcmNoL3g4Ni9w
Y2kvY29tbW9uLmMKQEAgLTQ5NCw2ICs0OTQsMjggQEAgaW50IF9faW5pdCBwY2liaW9zX2luaXQo
dm9pZCkKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIHZvaWQgX19pbml0IHBhcnNlX2J1c251bV9u
b2RlKGNoYXIgKnN0cikKK3sKKwlpbnQgYnVzLCBub2RlLCBjb3VudDsKKwljaGFyICpwOworCisJ
cCA9IHN0cjsKKwl3aGlsZSAoKnApIHsKKwkJY291bnQgPSAwOworCQlpZiAoc3NjYW5mKHAsICIl
eDoleCVuIiwgJmJ1cywgJm5vZGUsICZjb3VudCkgIT0gMikgeworCQkJcHJpbnRrKEtFUk5fRVJS
ICJQQ0k6IENhbid0IHBhcnNlIGJ1c251bV9ub2RlIGlucHV0OiAlc1xuIiwKKwkJCQkJcCk7CisJ
CQlicmVhazsKKwkJfQorCQlzZXRfbXBfYnVzX3RvX25vZGUoYnVzLCBub2RlKTsKKwkJcCArPSBj
b3VudDsKKwkJaWYgKCpwICE9ICcsJykKKwkJCWJyZWFrOworCQlwKys7CisJfQorfQorCisKIGNo
YXIgKiBfX2RldmluaXQgIHBjaWJpb3Nfc2V0dXAoY2hhciAqc3RyKQogewogCWlmICghc3RyY21w
KHN0ciwgIm9mZiIpKSB7CkBAIC01NzksNiArNjAxLDkgQEAgY2hhciAqIF9fZGV2aW5pdCAgcGNp
Ymlvc19zZXR1cChjaGFyICpzdHIpCiAJfSBlbHNlIGlmICghc3RyY21wKHN0ciwgIm5vY3JzIikp
IHsKIAkJcGNpX3Byb2JlIHw9IFBDSV9ST09UX05PX0NSUzsKIAkJcmV0dXJuIE5VTEw7CisJfSBl
bHNlIGlmICghc3RybmNtcChzdHIsICJidXNudW1fbm9kZT0iLCAxMikpIHsKKwkJcGFyc2VfYnVz
bnVtX25vZGUoc3RyICsgMTIpOworCQlyZXR1cm4gTlVMTDsKIAl9IGVsc2UgaWYgKCFzdHJjbXAo
c3RyLCAiZWFybHlkdW1wIikpIHsKIAkJcGNpX2Vhcmx5X2R1bXBfcmVncyA9IDE7CiAJCXJldHVy
biBOVUxMOwo=
--047d7b15ae45c3493c04c2c7b1a1--
