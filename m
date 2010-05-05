Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab0EEMLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:11:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60840 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab0EEMLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:11:06 -0400
X-User-Agent: K-9 Mail for Android
In-Reply-To: <4BE11E8A.2090804@redhat.com>
References: =?US-ASCII?Q?=3C1272812038-32484-1-git-send-email-avi=40redha?= =?US-ASCII?Q?t=2Ecom=3E=09_=3C1272812038-32484-2-git-send-email-avi?= =?US-ASCII?Q?=40redhat=2Ecom=3E=09_=3Cu2p73c1f2161005021038gce35c1bb?= =?US-ASCII?Q?pca6ec119d24e646e=40mail?= =?US-ASCII?Q?=2Egmail=2Ecom=3E=09_=3C4BDDBA18=2E30?= =?US-ASCII?Q?80909=40redhat=2Ecom=3E_=3C4BDF4407=2E8000503=40zytor=2Eco?= =?US-ASCII?Q?m=3E=09_=3C4BDFCF9F=2E3030600=40?= =?US-ASCII?Q?redhat=2Ecom=3E_=3C1272996927=2E2?= =?US-ASCII?Q?833=2E13=2Ecamel=40sbs-t61=2E?= =?US-ASCII?Q?sc=2Eintel=2Ecom=3E_=3C4BE06642=2E?= =?US-ASCII?Q?6080702=40zytor=2Ecom=3E_=3C4BE?= =?US-ASCII?Q?11E8A=2E2090804=40redhat=2Ecom=3E?=
Content-Type: multipart/mixed; boundary="----68ELJY5JJBR90F1U2IFQDG83D8VTBQ"
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 05 May 2010 05:10:04 -0700
To: Avi Kivity <avi@redhat.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Brian Gerst <brgerst@gmail.com>,
       "Cui, Dexuan" <dexuan.cui@intel.com>,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Message-ID: <6ba17d83-676c-4271-86ea-c97294f17b26@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------68ELJY5JJBR90F1U2IFQDG83D8VTBQ
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

WW91ciBjb2RlIGlzIGZ1bmN0aW9uYWxseSBlcXVpdmFsZW50IHRvIHRoZSBpbW1lZGlhdGUgdmFs
dWVzIHBhdGNoOyBuZWl0aGVyIHVzZXMgYSBkaXJlY3QgYnJhbmNoIHdoaWNoIHdvdWxkIGJlIG1v
cmUgZWZmaWNpZW50LgoKIkF2aSBLaXZpdHkiIDxhdmlAcmVkaGF0LmNvbT4gd3JvdGU6Cgo+T24g
MDUvMDQvMjAxMCAwOToyNCBQTSwgSC4gUGV0ZXIgQW52aW4gd3JvdGU6Cj4+Cj4+IEkgd291bGQg
bGlrZSB0byByZXF1ZXN0IG9uZSBjaGFuZ2UsIGhvd2V2ZXIuICBJIHdvdWxkIGxpa2UgdG8gc2Vl
IHRoZQo+PiBhbHRlcm5hdGl2ZXMgY29kZSB0byBiZToKPj4KPj4gCW1vdmIgJDAscmVnCj4+IAlt
b3ZiICQxLHJlZwo+Pgo+PiAuLi4gaW5zdGVhZCBvZiB1c2luZyB4b3IgKHdoaWNoIGhhcyB0byBi
ZSBwYWRkZWQgd2l0aCBOT1BzLCB3aGljaCBpcyBvZgo+PiBjb3Vyc2UgcG9pbnRsZXNzIHNpbmNl
IHRoZSBzbG90IGlzIGEgZml4ZWQgc2l6ZS4pCj4KPlJpZ2h0Lgo+Cj4+IEkgd291bGQgc3VnZ2Vz
dCB1c2luZwo+PiBhIGJ5dGUtc2l6ZWQgdmFyaWFibGUgaW5zdGVhZCBvZiBhIGR3b3JkLXNpemUg
dmFyaWFibGUgdG8gc2F2ZSBhIGZldwo+PiBieXRlcywgdG9vLgo+PiAgICAKPgo+SSB1c2VkIGEg
Ym9vbCwgYW5kIHRoZSBjb2RlIGFscmVhZHkgY29tcGlsZXMgdG8gYSBieXRlIG1vdi4gIFRob3Vn
aCBpdCAKPmNvdWxkIGJlIGFyZ3VlZCB0aGF0IGEgd29yZCBpbnN0cnVjdGlvbiBpcyBiZXR0ZXIg
c2luY2UgaXQgYXZvaWRzIGEgCj5mYWxzZSBkZXBlbmRlbmN5LCBhbmQgYWxsb3dzIGEgcHJlY2Vk
aW5nIGluc3RydWN0aW9uIHRoYXQgbW9kaWZpZXMgJXJlZyAKPnRvIGJlIGV4ZWN1dGVkIGFmdGVy
IHRoZSBtb3YgaW5zdHJ1Y3Rpb24uCj4KPj4gT25jZSB0aGUganVtcCBsYWJlbCBmcmFtZXdvcmsg
aXMgaW50ZWdyYXRlZCBhbmQgaGFzIG1hdHVyZWQsIEkgdGhpbmsgd2UKPj4gc2hvdWxkIGNvbnNp
ZGVyIHVzaW5nIGl0IHRvIHNhdmUgdGhlIG1vdi90ZXN0L2p1bXAuCj4+ICAgIAo+Cj5JSVJDIHRo
YXQgaGFzIGFuIGltcGxpZWQgdW5saWtlbHkoKSB3aGljaCBpc24ndCBzdWl0YWJsZSBoZXJlPwo+
Cj5QZXJoYXBzIHRoZSBpbW1lZGlhdGUgdmFsdWVzIHBhdGNoZXMuCj4KPi0tIAo+ZXJyb3IgY29t
cGlsaW5nIGNvbW1pdHRlZS5jOiB0b28gbWFueSBhcmd1bWVudHMgdG8gZnVuY3Rpb24KPgoKLS0g
ClNlbnQgZnJvbSBteSBBbmRyb2lkIHBob25lIHdpdGggSy05IE1haWwuIFBsZWFzZSBleGN1c2Ug
bXkgYnJldml0eS4=

------68ELJY5JJBR90F1U2IFQDG83D8VTBQ--

