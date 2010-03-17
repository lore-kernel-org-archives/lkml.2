Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab0CQTwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:52:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60376 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0CQTwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:52:07 -0400
X-User-Agent: K-9 Mail for Android
Content-Type: multipart/mixed; boundary="----HACMQT1QL9BJJOUSH1A1DIPEAOKK36"
MIME-Version: 1.0
Subject: Re: [patch 2/2] x86,pat Convert memtype_lock into an rw_lock.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 17 Mar 2010 12:51:14 -0700
To: Suresh Siddha <suresh.b.siddha@intel.com>, "holt@sgi.com" <holt@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Message-ID: <ff8c11be-b22d-4849-9b19-d9107c4fea47@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------HACMQT1QL9BJJOUSH1A1DIPEAOKK36
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

V2VsbCwgYXMgeW91IGtub3cgOikgdGdseCBhbmQgSSBhcmUgb24gdGhlIHJvYWQgLi4uIEknbGwg
dHJ5IHRvIGdldCB0byBpdCBvbiBGcmlkYXkgYmVmb3JlIEkgdGFrZSBvZmYgYWdhaW4uCgoiU3Vy
ZXNoIFNpZGRoYSIgPHN1cmVzaC5iLnNpZGRoYUBpbnRlbC5jb20+IHdyb3RlOgoKPk9uIE1vbiwg
MjAxMC0wMy0xNSBhdCAwNjoyMSAtMDcwMCwgaG9sdEBzZ2kuY29tIHdyb3RlOg0KPj4gQ29udmVy
dCB0aGUgbWVtdHlwZV9sb2NrIGZyb20gYSBzcGluX2xvY2sgdG8gYW4gcndfbG9jay4gIFRoZSBm
aXJzdA0KPj4gdmVyc2lvbiBvZiBteSBwYXRjaCBoYWQgdGhpcyBhbmQgaXQgZGlkIGltcHJvdmUg
cGVyZm9ybWFuY2UgZm9yIGZhdWx0DQo+PiBpbiB0aW1lcy4gIFRoZSBhdG9taWMgcGFnZSBmbGFn
cyBwYXRjaCAoZmlyc3QgaW4gdGhlIHNlcmllcykgaW1wcm92ZXMNCj4+IHRoaW5ncyBtdWNoIGdy
ZWF0ZXIgZm9yIHJhbSBwYWdlcy4gIFRoaXMgcGF0Y2ggaXMgdG8gaGVscCB0aGUgb3RoZXIgcGFn
ZXMuDQo+PiANCj4NCj5BY2tlZC1ieTogU3VyZXNoIFNpZGRoYSA8c3VyZXNoLmIuc2lkZGhhQGlu
dGVsLmNvbT4NCj4NCj5YODYgZm9sa3MsIGNhbiB5b3UgcGxlYXNlIHF1ZXVlICBib3RoIHRoZXNl
IHBhdGNoZXMgaWYgeW91IGRvbid0IGhhdmUNCj5hbnkgb2JqZWN0aW9ucy4NCj4NCj50aGFua3Ms
DQo+c3VyZXNoDQo+DQoKLS0KU2VudCBmcm9tIG15IG1vYmlsZSBwaG9uZSwgcGFyZG9uIGFueSBs
YWNrIG9mIGZvcm1hdHRpbmcu

------HACMQT1QL9BJJOUSH1A1DIPEAOKK36--

