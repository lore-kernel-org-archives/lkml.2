Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1LRCdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 21:33:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59385 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1LRCdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 21:33:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111217092935.2c2e075e@jbarnes-desktop>
References: <20111217092935.2c2e075e@jbarnes-desktop>
Date: Sat, 17 Dec 2011 18:33:37 -0800
X-Google-Sender-Auth: kIYWuAzYY16NwYXzyZ_1Jsl4pQg
Message-ID: <CAE9FiQWueS=9aSAH4fLz=EpE=A_WanKU6pbfnR2a4gsymWjnDA@mail.gmail.com>
Subject: Re: [git pull] PCI fixes
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae9cdbf6f46fdb604b454a9aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9cdbf6f46fdb604b454a9aa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 17, 2011 at 9:29 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wr=
ote:
> Ram Pai (1):
> =A0 =A0 =A0PCI: defer enablement of SRIOV BARS

oh, no!

It seems you let the old version slip into linus tree.

Now we need attached patch get into linus tree.

Thanks

Yinghai Lu

--14dae9cdbf6f46fdb604b454a9aa
Content-Type: text/x-patch; charset=US-ASCII; name="fix_sriov_late.patch"
Content-Disposition: attachment; filename="fix_sriov_late.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwbfw4ye1

W1BBVENIXSBwY2k6IEZpeCBob3RwbHVnIG9mIEV4cHJlc3MgTW9kdWxlIHdpdGggcGNpIGJyaWRn
ZXMKCkZvdW5kIGhvdHBsdWcgb2Ygb25lIHNldHVwIGRvZXMgbm90IHdvcmsgd2l0aCByZWNlbnQg
Y2hhbmdlIGluIHBjaSB0cmVlLgoKQWZ0ZXIgY2hlY2tpbmcgdGhlIGJyaWRnZSBjb25mIHNldHVw
LCBmb3VuZCBicmlkZ2VzIGdldCBhc3NpZ25lZCwgYnV0IG5vdCBnZXQgZW5hYmxlZC4KCkZpbmFs
bHkgZm91bmQgZm9sbG93aW5nIGNvbW1pdCwgc2ltcGxlbHkgaWdub3JlIGJyaWRnZSByZXNvdXJj
ZSB3aGVuIGVuYWJsaW5nIHBjaSBkZXZpY2UuCgp8IGNvbW1pdCBiYmVmOThhYjBmMDE5ZjFiMGMy
NWMxYWNkZjE2ODNjNjg5MzNkNDFiCnwgQXV0aG9yOiBSYW0gUGFpIDxsaW51eHJhbUB1cy5pYm0u
Y29tPgp8IERhdGU6ICAgU3VuIE5vdiA2IDEwOjMzOjEwIDIwMTEgKzA4MDAKfAp8ICAgIFBDSTog
ZGVmZXIgZW5hYmxlbWVudCBvZiBTUklPViBCQVJTCnwuLi4KfCAgICBOT1RFOiBOb3RlLCB0aGVy
ZSBpcyBzdWJ0bGUgY2hhbmdlIGluIHRoZSBwY2lfZW5hYmxlX2RldmljZSgpIEFQSS4gIEFueQp8
ICAgIGRyaXZlciB0aGF0IGRlcGVuZHMgb24gU1JJT1YgQkFSUyB0byBiZSBlbmFibGVkIGluIHBj
aV9lbmFibGVfZGV2aWNlKCkKfCAgICBjYW4gZmFpbC4KClB1dCBiYWNrIGJyaWRnZSByZXNvdXJj
ZSBhbmQgUk9NIHJlc291cmNlIGNoZWNraW5nIHRvIGZpeCB0aGUgcHJvYmxlbS4KClRoYXQgc2hv
dWxkIGZpeCByZWdyZXNzaW9uIGxpa2UgQklPUyBkb2VzIG5vdCBhc3NpZ24gY29ycmVjdCByZXNv
dXJjZSB0byBicmlkZ2UuCgpEaXNjdXNzaW9uIGNhbiBiZSBmb3VuZCBhdDoKCWh0dHA6Ly93d3cu
c3Bpbmljcy5uZXQvbGlzdHMvbGludXgtcGNpL21zZzEyODc0Lmh0bWwKClNpZ25lZC1vZmYtYnk6
IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9wY2kvcGNpLmMg
fCAgICA2ICsrKysrLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlv
bigtKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9wY2kuYwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9wY2kuYworKysgbGludXgtMi42L2RyaXZlcnMvcGNp
L3BjaS5jCkBAIC0xMTM5LDcgKzExMzksMTEgQEAgc3RhdGljIGludCBfX3BjaV9lbmFibGVfZGV2
aWNlX2ZsYWdzKHN0cgogCWlmIChhdG9taWNfYWRkX3JldHVybigxLCAmZGV2LT5lbmFibGVfY250
KSA+IDEpCiAJCXJldHVybiAwOwkJLyogYWxyZWFkeSBlbmFibGVkICovCiAKLQlmb3IgKGkgPSAw
OyBpIDwgUENJX1JPTV9SRVNPVVJDRTsgaSsrKQorCS8qIG9ubHkgc2tpcCBzcmlvdiByZWxhdGVk
ICovCisJZm9yIChpID0gMDsgaSA8PSBQQ0lfUk9NX1JFU09VUkNFOyBpKyspCisJCWlmIChkZXYt
PnJlc291cmNlW2ldLmZsYWdzICYgZmxhZ3MpCisJCQliYXJzIHw9ICgxIDw8IGkpOworCWZvciAo
aSA9IFBDSV9CUklER0VfUkVTT1VSQ0VTOyBpIDwgREVWSUNFX0NPVU5UX1JFU09VUkNFOyBpKysp
CiAJCWlmIChkZXYtPnJlc291cmNlW2ldLmZsYWdzICYgZmxhZ3MpCiAJCQliYXJzIHw9ICgxIDw8
IGkpOwogCg==
--14dae9cdbf6f46fdb604b454a9aa--
