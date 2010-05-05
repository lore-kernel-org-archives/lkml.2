Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab0EEMNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:13:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60881 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934264Ab0EEMNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:13:09 -0400
X-User-Agent: K-9 Mail for Android
In-Reply-To: <4BE11E8A.2090804@redhat.com>
References: =?US-ASCII?Q?=3C1272812038-32484-1-git-send-email-avi=40redha?= =?US-ASCII?Q?t=2Ecom=3E=09_=3C1272812038-32484-2-git-send-email-avi?= =?US-ASCII?Q?=40redhat=2Ecom=3E=09_=3Cu2p73c1f2161005021038gce35c1bb?= =?US-ASCII?Q?pca6ec119d24e646e=40mail?= =?US-ASCII?Q?=2Egmail=2Ecom=3E=09_=3C4BDDBA18=2E30?= =?US-ASCII?Q?80909=40redhat=2Ecom=3E_=3C4BDF4407=2E8000503=40zytor=2Eco?= =?US-ASCII?Q?m=3E=09_=3C4BDFCF9F=2E3030600=40?= =?US-ASCII?Q?redhat=2Ecom=3E_=3C1272996927=2E2?= =?US-ASCII?Q?833=2E13=2Ecamel=40sbs-t61=2E?= =?US-ASCII?Q?sc=2Eintel=2Ecom=3E_=3C4BE06642=2E?= =?US-ASCII?Q?6080702=40zytor=2Ecom=3E_=3C4BE?= =?US-ASCII?Q?11E8A=2E2090804=40redhat=2Ecom=3E?=
Content-Type: multipart/mixed; boundary="----Y7FVY1JO6VB3J2FQHXBNF2ER9H2WNG"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 05 May 2010 05:12:11 -0700
To: Avi Kivity <avi@redhat.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Brian Gerst <brgerst@gmail.com>,
       "Cui, Dexuan" <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Message-ID: <04186ca0-c685-4a12-a3d2-112e8d1abf28@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------Y7FVY1JO6VB3J2FQHXBNF2ER9H2WNG
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

WW91IGRvbid0IHdhbnQgdG8gdXNlIGJvb2wgc2luY2Ugc29tZSBnY2MgdmVyc2lvbnMgZG9uJ3Qg
aGFuZGxlIGJvb2wgaW4gYXNtIHdlbGw7IHVzZSBhIHU4IGluc3RlYWQuIAoKIkF2aSBLaXZpdHki
IDxhdmlAcmVkaGF0LmNvbT4gd3JvdGU6Cgo+T24gMDUvMDQvMjAxMCAwOToyNCBQTSwgSC4gUGV0
ZXIgQW52aW4gd3JvdGU6Cj4+Cj4+IEkgd291bGQgbGlrZSB0byByZXF1ZXN0IG9uZSBjaGFuZ2Us
IGhvd2V2ZXIuICBJIHdvdWxkIGxpa2UgdG8gc2VlIHRoZQo+PiBhbHRlcm5hdGl2ZXMgY29kZSB0
byBiZToKPj4KPj4gCW1vdmIgJDAscmVnCj4+IAltb3ZiICQxLHJlZwo+Pgo+PiAuLi4gaW5zdGVh
ZCBvZiB1c2luZyB4b3IgKHdoaWNoIGhhcyB0byBiZSBwYWRkZWQgd2l0aCBOT1BzLCB3aGljaCBp
cyBvZgo+PiBjb3Vyc2UgcG9pbnRsZXNzIHNpbmNlIHRoZSBzbG90IGlzIGEgZml4ZWQgc2l6ZS4p
Cj4KPlJpZ2h0Lgo+Cj4+IEkgd291bGQgc3VnZ2VzdCB1c2luZwo+PiBhIGJ5dGUtc2l6ZWQgdmFy
aWFibGUgaW5zdGVhZCBvZiBhIGR3b3JkLXNpemUgdmFyaWFibGUgdG8gc2F2ZSBhIGZldwo+PiBi
eXRlcywgdG9vLgo+PiAgICAKPgo+SSB1c2VkIGEgYm9vbCwgYW5kIHRoZSBjb2RlIGFscmVhZHkg
Y29tcGlsZXMgdG8gYSBieXRlIG1vdi4gIFRob3VnaCBpdCAKPmNvdWxkIGJlIGFyZ3VlZCB0aGF0
IGEgd29yZCBpbnN0cnVjdGlvbiBpcyBiZXR0ZXIgc2luY2UgaXQgYXZvaWRzIGEgCj5mYWxzZSBk
ZXBlbmRlbmN5LCBhbmQgYWxsb3dzIGEgcHJlY2VkaW5nIGluc3RydWN0aW9uIHRoYXQgbW9kaWZp
ZXMgJXJlZyAKPnRvIGJlIGV4ZWN1dGVkIGFmdGVyIHRoZSBtb3YgaW5zdHJ1Y3Rpb24uCj4KPj4g
T25jZSB0aGUganVtcCBsYWJlbCBmcmFtZXdvcmsgaXMgaW50ZWdyYXRlZCBhbmQgaGFzIG1hdHVy
ZWQsIEkgdGhpbmsgd2UKPj4gc2hvdWxkIGNvbnNpZGVyIHVzaW5nIGl0IHRvIHNhdmUgdGhlIG1v
di90ZXN0L2p1bXAuCj4+ICAgIAo+Cj5JSVJDIHRoYXQgaGFzIGFuIGltcGxpZWQgdW5saWtlbHko
KSB3aGljaCBpc24ndCBzdWl0YWJsZSBoZXJlPwo+Cj5QZXJoYXBzIHRoZSBpbW1lZGlhdGUgdmFs
dWVzIHBhdGNoZXMuCj4KPi0tIAo+ZXJyb3IgY29tcGlsaW5nIGNvbW1pdHRlZS5jOiB0b28gbWFu
eSBhcmd1bWVudHMgdG8gZnVuY3Rpb24KPgoKLS0gClNlbnQgZnJvbSBteSBBbmRyb2lkIHBob25l
IHdpdGggSy05IE1haWwuIFBsZWFzZSBleGN1c2UgbXkgYnJldml0eS4=

------Y7FVY1JO6VB3J2FQHXBNF2ER9H2WNG--

