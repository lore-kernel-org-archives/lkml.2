Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0DZXEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:04:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40567 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab0DZXEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:04:13 -0400
X-User-Agent: K-9 Mail for Android
Content-Type: multipart/mixed; boundary="----XALGEAD1SY1OEWC5WDSMQV24L9TL1O"
MIME-Version: 1.0
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below   BIOS_END
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 26 Apr 2010 16:02:57 -0700
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>, Yinghai <yinghai.lu@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Message-ID: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------XALGEAD1SY1OEWC5WDSMQV24L9TL1O
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

SSBkb24ndCB0aGluayBpdCdzIHN1ZmZpY2llbnQsIGFjdHVhbGx5LiAgV2UgcmVndWxhcmx5IHNl
ZSBtYWNoaW5lcyB3aGVyZSBkZXZpY2VzIHBvaW50IGludG8gZTgyMF9yZXNlcnZlZCBtZW1vcnkg
YWJvdmUgMSBNQiAtIGJlY2F1c2UgaXQncyBhIHBsYXRmb3JtIGRldmljZSBvciBiZWNhdXNlIGZp
cm13YXJlIChlLmcuIHNtbSkgaXMgdG91Y2hpbmcgdGhlIGRldmljZS4gIEkgdGhpbmsgQmpvcm4n
cyBmaXggaXMgZ3JlYXQgZm9yIC4zNCwgYnV0IGxvbmdlciB0ZXJtIEkgdGhpbmsgd2UgbmVlZCB0
byBzdHJ1Y3R1cmUgdGhlIGNvZGUgdG8gYWN0dWFsbHkgaGFuZGxlIHJlc2VydmVkIHJlZ2lvbnMg
ZGlmZmVyZW50bHkgZnJvbSBvY2N1cGllZC9mb3JiaWRkZW4gcmVnaW9ucy4KCiJKZXNzZSBCYXJu
ZXMiIDxqYmFybmVzQHZpcnR1b3VzZ2Vlay5vcmc+IHdyb3RlOgoKPk9uIE1vbiwgMjYgQXByIDIw
MTAgMTQ6NDQ6NTAgLTA3MDAKPiJILiBQZXRlciBBbnZpbiIgPGhwYUB6eXRvci5jb20+IHdyb3Rl
Ogo+Cj4+ID4KPj4gPiBBZ3JlZWQuICBUaGUgdHJpY2tpZXIgcGFydCBpcyBoYW5kbGluZyBhbnkg
cGxhdGZvcm0gZGV2aWNlcyB0aGF0Cj4+ID4gcmVxdWVzdF9yZXNvdXJjZSBhZ2FpbnN0IHRoYXQg
c3BhY2UuICBCdXQgbWF5YmUgd2UgZG9uJ3QgbmVlZCB0byBkbwo+PiA+IGFueXRoaW5nIHNwZWNp
YWw7IGp1c3QgbWFraW5nIHN1cmUgd2UgYXZvaWQgaXQgaW4gdGhlIFBDSSAiQklPUyIgY29kZQo+
PiA+IGFzIEJqb3JuIGRpZCBtYXkgYmUgc3VmZmljaWVudC4KPj4gPgo+PiAKPj4gV2h5IGlzIHRo
YXQgaGFyZD8gIElmIGEgcGxhdGZvcm0gZGV2aWNlIGRvZXMgYSByZXF1ZXN0X3Jlc291cmNlIGFn
YWluc3QKPj4gdGhhdCBzcGFjZSwgaXQncyBhIHJlcXVlc3QgZm9yIHNwZWNpZmljIGFkZHJlc3Mg
c3BhY2UgYW5kIGl0IHNob3VsZCBiZQo+PiBncmFudGVkLgo+Cj5JIHdhcyB0aGlua2luZyBpZiB3
ZSBtYWRlIGl0IGEgc3BlY2lhbCByZXNvdXJjZSB0eXBlIHdlJ2QgaGF2ZSB0bwo+Y2hhbmdlIGFu
eSBwbGF0Zm9ybSBkcml2ZXJzIHRvIHVzZSBpdDsgaS5lLiBpdCB3b3VsZG4ndCBiZQo+SU9SRVNP
VVJDRV9NRU0gb3IgSU9SRVNPVVJDRV9JTyBidXQgSU9SRVNPVVJDRV9EUkFHT05TLiAgVGhhdCB3
YXkgaXQKPndvdWxkbid0IGJlIHBhcnQgb2YgdGhlIG5vcm1hbCByZXNvdXJjZSBzcGFjZS4KPgo+
QnV0IHRoYXQncyBkZWZpbml0ZWx5IG92ZXJraWxsLiAgSSB0aGluayBCam9ybidzIGZpeCBpcyBz
dWZmaWNpZW50Lgo+Cj4tLSAKPkplc3NlIEJhcm5lcywgSW50ZWwgT3BlbiBTb3VyY2UgVGVjaG5v
bG9neSBDZW50ZXIKCi0tIApTZW50IGZyb20gbXkgQW5kcm9pZCBwaG9uZSB3aXRoIEstOSBNYWls
LiBQbGVhc2UgZXhjdXNlIG15IGJyZXZpdHku

------XALGEAD1SY1OEWC5WDSMQV24L9TL1O--

