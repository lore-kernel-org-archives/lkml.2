Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0D0CHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 22:07:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42489 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0D0CHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 22:07:37 -0400
X-User-Agent: K-9 Mail for Android
Content-Type: multipart/mixed; boundary="----FSA9T7HERVFW45ATCK5VEG3ILQP3BQ"
MIME-Version: 1.0
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below    BIOS_END
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 26 Apr 2010 19:02:49 -0700
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>, Yinghai <yinghai.lu@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Message-ID: <83816598-e2c2-42fc-b029-5dead0e73abd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------FSA9T7HERVFW45ATCK5VEG3ILQP3BQ
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

VGhlIDEgTUIgcmFuZ2UgaXMgb25seSBvbmUgY2FzZSBvZiBhIHByZXJlc2VydmVkIHNwYWNlLiAg
SXQncyBzcGVjaWFsIG9ubHkgaW4gdGhlIHNlbnNlIHRoYXQgaXQgaXMgKmFsd2F5cyogcmVzZXJ2
ZWQsIGV2ZW4gaWYgdGhlIG1hcCBkb2Vzbid0IG1hcmsgaXQgYXMgc3VjaC4gIEZpeGVkIChvciBT
TU0tdXNlZCkgcmVzb3VyY2VzIGluIHJlc2VydmVkIHNwYWNlIGFib3ZlIDEgTUIgYXJlIGV4YWN0
bHkgdGhlIHNhbWUgaXNzdWUuCgoiSmVzc2UgQmFybmVzIiA8amJhcm5lc0B2aXJ0dW91c2dlZWsu
b3JnPiB3cm90ZToKCj5PbiBNb24sIDI2IEFwciAyMDEwIDE4OjI3OjI3IC0wNzAwIChQRFQpCj5M
aW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3RlOgo+Cj4+
IAo+PiAKPj4gT24gTW9uLCAyNiBBcHIgMjAxMCwgSmVzc2UgQmFybmVzIHdyb3RlOgo+PiA+IAo+
PiA+IEdsYWQgd2UgYWdyZWUuICBBcyBJIHNhaWQgKGFuZCBlY2hvaW5nIEJqb3JuKSwgSSB0aGlu
ayBpdCB3b3VsZCBiZSBiZXN0Cj4+ID4gdG8gcmVzZXJ2ZSB0aGlzIHNwYWNlIGluIGEgd2F5IHRo
YXQgZG9lc24ndCBqdXN0IHVzZSBJT1JFU09VUkNFX0JVU1kuCj4+ID4gV2Ugd2FudCBhbmQgbmVl
ZCB0byBkbyBhbGxvY2F0aW9ucyBmcm9tIHRoZSBzcGVjaWFsIHJlZ2lvbiwgc28gd2UKPj4gPiBz
aG91bGQgbWFyayBpdCBhcyBzdWNoLgo+PiAKPj4gSSB0aGluayBCam9ybidzIHBhdGNoIHRvIHBj
aWJpb3NfYWxpZ25fcmVzb3VyY2UoKSBpcyByZWFsbHkgZ29vZCBhbmQgCj4+IGNsZXZlciwgYW5k
IEkgdGhpbmsgaXQgc2hvdWxkIHRha2UgY2FyZSBvZiB0aGUgbmVlZCBmb3IgSU9SRVNPVVJDRV9C
VVNZLCAKPj4gbm8/IFdlIGRvIHdhbnQgdG8gbGV0IGRldmljZXMgdGhhdCBhcmUgX2FscmVhZHlf
IGFsbG9jYXRlZCB0aGVyZSBpbnNlcnQgCj4+IHRoZWlyIHJlc291cmNlcywgaXQncyBqdXN0IHRo
YXQgd2UgbmV2ZXIgd2FudCB0byBhbGxvY2F0ZSBuZXcgb25lcyBpbiB0aGUgCj4+IGxvdyAxTSBy
ZWdpb24uCj4+IAo+PiBEbyB3ZSBhY3R1YWxseSBoYXZlIGEgcmVncmVzc2lvbiBsZWZ0IHdpdGgg
Qmpvcm4ncyBwYXRjaD8KPgo+Tm8sIEkgdGhpbmsgd2UncmUgY292ZXJlZC4gIEJ1dCBpdCBzb3Vu
ZGVkIGxpa2UgUGV0ZXIgd2FzIGFsc28KPmNvbmNlcm5lZCBhYm91dCBtYWtpbmcgbmV3IGFsbG9j
YXRpb25zIGZyb20gdGhlIDFNIHNwYWNlLCB3aGljaCB3b3VsZAo+bWVhbiB3ZSdkIG5lZWQgc29t
ZXRoaW5nIG90aGVyIHRoYW4gdGhlIElPUkVTT1VSQ0VfQlVTWSBiaXQuICBCdXQgbWF5YmUKPkJq
b3JuJ3MgcGF0Y2ggcGx1cyBzaW1wbHkgcmVtb3ZpbmcgdGhlIElPUkVTT1VSQ0VfQlVTWSBsaW5l
IGlzCj5zdWZmaWNpZW50IGZvciB0aGF0LiAgVGhlIGRvd25zaWRlIHRoZXJlIGlzIHRoYXQgaXQg
ZG9lc24ndCBjbGVhcmx5Cj5jb21tdW5pY2F0ZSB0aGUgc3BlY2lhbCBuYXR1cmUgb2YgdGhlIDFN
IHJlZ2lvbi4KPgo+LS0gCj5KZXNzZSBCYXJuZXMsIEludGVsIE9wZW4gU291cmNlIFRlY2hub2xv
Z3kgQ2VudGVyCgotLSAKU2VudCBmcm9tIG15IEFuZHJvaWQgcGhvbmUgd2l0aCBLLTkgTWFpbC4g
UGxlYXNlIGV4Y3VzZSBteSBicmV2aXR5Lg==

------FSA9T7HERVFW45ATCK5VEG3ILQP3BQ--

