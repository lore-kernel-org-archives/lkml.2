Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2LRCm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:42:26 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:34859 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2LRCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:42:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWe+5+Oh7gKT1mCKn+sEm0P8_azfLV=WN6xWHKp2j-eUA@mail.gmail.com>
References: <20121211170605.GD28827@liondog.tnic>
	<50C82ABF.3020907@zytor.com>
	<20121212133853.GC8760@liondog.tnic>
	<50C963B1.3040609@zytor.com>
	<50C96717.3020407@zytor.com>
	<20121213191317.GE31485@liondog.tnic>
	<50CA4A7A.10104@zytor.com>
	<CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
	<50CB8213.9000908@zytor.com>
	<CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
	<CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
	<CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
	<50CCCFD0.7030704@linux.intel.com>
	<CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
	<50CCEE49.3080801@zytor.com>
	<CAE9FiQV6tmHqnwOX8Rh3heaG1PQ9YQNN45esMQjqZP8Upw0Y-g@mail.gmail.com>
	<CAE9FiQUSve-5zuD8JyOK-eeJwTu6-E7ZnYCvc74jPVWwxhLP4g@mail.gmail.com>
	<CAE9FiQUWFaOkLNc8fJw=bEUwOkusadriMn0Oajk+F64vo5Eysw@mail.gmail.com>
	<CAE9FiQVG1WvtoUNK3ecfmSCocJZt694yrm7=iaOciD47GN=9EA@mail.gmail.com>
	<50CFA6A4.7010805@zytor.com>
	<CAE9FiQUx-T2ZFyBtrdLjzkUO50LObMv_nOEUNPwU+wPQscD1_A@mail.gmail.com>
	<CAE9FiQXbBXucvAkDf6O3XFS-6mFDW0U9qKfA8CZbDRpq=e0OrQ@mail.gmail.com>
	<CAE9FiQWe+5+Oh7gKT1mCKn+sEm0P8_azfLV=WN6xWHKp2j-eUA@mail.gmail.com>
Date: Mon, 17 Dec 2012 18:42:22 -0800
X-Google-Sender-Auth: yNykJTgWB8loPDKXRwGTg9Zls74
Message-ID: <CAE9FiQV6ZnMKKAeH=3rmrTW62Y95_2SWLcFrAM9P0+gbamCn_A@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jan Kiszka <jan.kiszka@web.de>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: multipart/mixed; boundary=001517478216861c3104d11772ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001517478216861c3104d11772ad
Content-Type: text/plain; charset=ISO-8859-1

Jan,

Can you check if attached patch is going to break KGDB?

Thanks

Yinghai

--001517478216861c3104d11772ad
Content-Type: application/octet-stream; 
	name="move_down_early_trap_init.patch"
Content-Disposition: attachment; filename="move_down_early_trap_init.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hauffufu0

U3ViamVjdDogW1BBVENIXSB4ODY6IE1vdmUgZWFybHlfdHJhcF9wZl9pbml0IGRvd24gYWZ0ZXIg
aW5pdF9tZW1fbWFwcGluZwoKV2l0aCAjUEYgaGFuZGxlciBoZWxwLCB3ZSBjYW4gc2V0IG1lbSBt
YXBwaW5nIGZyb20gYmxhbmsgaW4gaW5pdF9sZXZlbDRfcGd0CgpidXQgd2UgbmVlZCB0byBrZWVw
IHRoYXQgaGFuZGxlciBhbGl2ZSB1bnRpbCBpbml0X21lbV9tYXBwaW5nIGFuZCBkb24ndAoKbGV0
IGVhcmx5X3RyYXBfaW5pdCB0byB0cmFzaCB0aGF0IGVhcmx5ICNQRiBoYW5kbGVyLgoKU28gc3Bs
aXQgZWFybHlfdHJhcF9wZl9pbml0IG91dCBhbmQgbW92ZSBpdCBkb3duLgoKU2lnbmVkLW9mZi1i
eTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9pbmNsdWRl
L2FzbS9wcm9jZXNzb3IuaCB8ICAgIDMgKystCiBhcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyAgICAg
ICAgICB8ICAgIDQgKysrLQogYXJjaC94ODYva2VybmVsL3RyYXBzLmMgICAgICAgICAgfCAgICA4
ICsrKysrKy0tCiAzIGZpbGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25z
KC0pCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0K
LS0tIGxpbnV4LTIuNi5vcmlnL2FyY2gveDg2L2tlcm5lbC9zZXR1cC5jCisrKyBsaW51eC0yLjYv
YXJjaC94ODYva2VybmVsL3NldHVwLmMKQEAgLTY4NSw3ICs2ODUsNyBAQCB2b2lkIF9faW5pdCBz
ZXR1cF9hcmNoKGNoYXIgKipjbWRsaW5lX3ApCiAJICovCiAJb2xwY19vZndfZGV0ZWN0KCk7CiAK
LQllYXJseV90cmFwX2luaXQoKTsKKwllYXJseV90cmFwX2RiX2JwX2luaXQoKTsKIAllYXJseV9j
cHVfaW5pdCgpOwogCWVhcmx5X2lvcmVtYXBfaW5pdCgpOwogCkBAIC05MTcsNiArOTE3LDggQEAg
dm9pZCBfX2luaXQgc2V0dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQogCiAJaW5pdF9tZW1fbWFw
cGluZygpOwogCisJZWFybHlfdHJhcF9wZl9pbml0KCk7CisKIAlzZXR1cF9yZWFsX21vZGUoKTsK
IAogCW1lbWJsb2NrLmN1cnJlbnRfbGltaXQgPSBnZXRfbWF4X21hcHBlZCgpOwpJbmRleDogbGlu
dXgtMi42L2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxp
bnV4LTIuNi5vcmlnL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCisrKyBsaW51eC0y
LjYvYXJjaC94ODYvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmgKQEAgLTczMCw3ICs3MzAsOCBAQCBl
bnVtIGlkbGVfYm9vdF9vdmVycmlkZSB7SURMRV9OT19PVkVSUklECiBleHRlcm4gdm9pZCBlbmFi
bGVfc2VwX2NwdSh2b2lkKTsKIGV4dGVybiBpbnQgc3lzZW50ZXJfc2V0dXAodm9pZCk7CiAKLWV4
dGVybiB2b2lkIGVhcmx5X3RyYXBfaW5pdCh2b2lkKTsKK2V4dGVybiB2b2lkIGVhcmx5X3RyYXBf
ZGJfYnBfaW5pdCh2b2lkKTsKK2V4dGVybiB2b2lkIGVhcmx5X3RyYXBfcGZfaW5pdCh2b2lkKTsK
IAogLyogRGVmaW5lZCBpbiBoZWFkLlMgKi8KIGV4dGVybiBzdHJ1Y3QgZGVzY19wdHIJCWVhcmx5
X2dkdF9kZXNjcjsKSW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvdHJhcHMuYwo9PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwvdHJhcHMuYworKysgbGlu
dXgtMi42L2FyY2gveDg2L2tlcm5lbC90cmFwcy5jCkBAIC02ODksMTUgKzY4OSwxOSBAQCBkb3Ry
YXBsaW5rYWdlIHZvaWQgZG9faXJldF9lcnJvcihzdHJ1Y3QKICNlbmRpZgogCiAvKiBTZXQgb2Yg
dHJhcHMgbmVlZGVkIGZvciBlYXJseSBkZWJ1Z2dpbmcuICovCi12b2lkIF9faW5pdCBlYXJseV90
cmFwX2luaXQodm9pZCkKK3ZvaWQgX19pbml0IGVhcmx5X3RyYXBfZGJfYnBfaW5pdCh2b2lkKQog
ewogCXNldF9pbnRyX2dhdGVfaXN0KFg4Nl9UUkFQX0RCLCAmZGVidWcsIERFQlVHX1NUQUNLKTsK
IAkvKiBpbnQzIGNhbiBiZSBjYWxsZWQgZnJvbSBhbGwgKi8KIAlzZXRfc3lzdGVtX2ludHJfZ2F0
ZV9pc3QoWDg2X1RSQVBfQlAsICZpbnQzLCBERUJVR19TVEFDSyk7Ci0Jc2V0X2ludHJfZ2F0ZShY
ODZfVFJBUF9QRiwgJnBhZ2VfZmF1bHQpOwogCWxvYWRfaWR0KCZpZHRfZGVzY3IpOwogfQogCit2
b2lkIF9faW5pdCBlYXJseV90cmFwX3BmX2luaXQodm9pZCkKK3sKKwlzZXRfaW50cl9nYXRlKFg4
Nl9UUkFQX1BGLCAmcGFnZV9mYXVsdCk7Cit9CisKIHZvaWQgX19pbml0IHRyYXBfaW5pdCh2b2lk
KQogewogCWludCBpOwo=
--001517478216861c3104d11772ad--
