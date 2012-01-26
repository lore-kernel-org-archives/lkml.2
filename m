Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2AZROU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:14:20 -0500
Received: from jdl.com ([208.123.74.7]:40988 "EHLO jdl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab2AZROS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:14:18 -0500
Message-Id: <E1RqStl-0008Di-0z@jdl.com>
To: Stephen Warren <swarren@nvidia.com>
cc: Felipe Balbi <balbi@ti.com>,
        "David Gibson (david@gibson.dropbear.id.au)" 
	<david@gibson.dropbear.id.au>,
        "mmarek@suse.cz" <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] scripts: dtc: fix compile warnings
In-reply-to: <74CDBE0F657A3D45AFBB94109FB122FF178CB8233B@HQMAIL01.nvidia.com>
References: <1327576807-19216-1-git-send-email-balbi@ti.com> <74CDBE0F657A3D45AFBB94109FB122FF178CB8233B@HQMAIL01.nvidia.com>
Comments: In-reply-to Stephen Warren <swarren@nvidia.com>
   message dated "Thu, 26 Jan 2012 08:58:31 -0800."
Date: Thu, 26 Jan 2012 11:14:08 -0600
From: Jon Loeliger <jdl@jdl.com>
X-Spam-Score: -0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> RmVsaXBlIEJhbGJpIHdyb3RlIGF0IFRodXJzZGF5LCBKYW51YXJ5IDI2LCAyMDEyIDQ6MjAgQU06
> DQo+IEZpeCBmb2xsb3dpbmcgY29tcGlsZSB3YXJuaW5nczoNCj4gDQo+IHNjcmlwdHMvZHRjL2Zs
> YXR0cmVlLmM6IEluIGZ1bmN0aW9uIOKAmGZsYXRfcmVhZF9tZW1fcmVzZXJ2ZeKAmToNCj4gc2Ny
> aXB0cy9kdGMvZmxhdHRyZWUuYzo3MDA6MTQ6IHdhcm5pbmc6IHZhcmlhYmxlIOKAmHDigJkgc2V0
> IGJ1dCBub3QgdXNlZA0KPiAJWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+IA0KPiBzY3Jp
> cHRzL2R0Yy9kdGMuYzogSW4gZnVuY3Rpb24g4oCYbWFpbuKAmToNCj4gc2NyaXB0cy9kdGMvZHRj
> LmM6MTA0OjE3OiB3YXJuaW5nOiB2YXJpYWJsZSDigJhjaGVja+KAmSBzZXQgYnV0IG5vdCB1c2Vk
> DQo+IAlbLVd1bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEZl
> bGlwZSBCYWxiaSA8YmFsYmlAdGkuY29tPg0KDQpJIHRoaW5rIHlvdSB3YW50IHRvIHNlbmQgdGhp
> cyB0byB0aGUgdXBzdHJlYW0gZHRjIG1haW50YWluZXJzOyBJJ3ZlIENDJ2QNCnRoZW0gb24gdGhp
> cyBtYWlsLg0KDQo+IC0tLQ0KPiAgc2NyaXB0cy9kdGMvZHRjLmMgICAgICB8ICAgIDUgKy0tLS0N
> Cj4gIHNjcmlwdHMvZHRjL2ZsYXR0cmVlLmMgfCAgICAyIC0tDQo+ICAyIGZpbGVzIGNoYW5nZWQs
> IDEgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9zY3Jp
> cHRzL2R0Yy9kdGMuYyBiL3NjcmlwdHMvZHRjL2R0Yy5jDQo+IGluZGV4IDQ1MWM5MmQuLjJlZjVl
> MmUgMTAwNjQ0DQo+IC0tLSBhL3NjcmlwdHMvZHRjL2R0Yy5jDQo+ICsrKyBiL3NjcmlwdHMvZHRj
> L2R0Yy5jDQo+IEBAIC0xMDEsNyArMTAxLDcgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKmFy
> Z3ZbXSkNCj4gIAljb25zdCBjaGFyICpvdXRmb3JtID0gImR0cyI7DQo+ICAJY29uc3QgY2hhciAq
> b3V0bmFtZSA9ICItIjsNCj4gIAljb25zdCBjaGFyICpkZXBuYW1lID0gTlVMTDsNCj4gLQlpbnQg
> Zm9yY2UgPSAwLCBjaGVjayA9IDAsIHNvcnQgPSAwOw0KPiArCWludCBmb3JjZSA9IDAsIHNvcnQg
> PSAwOw0KPiAgCWNvbnN0IGNoYXIgKmFyZzsNCj4gIAlpbnQgb3B0Ow0KPiAgCUZJTEUgKm91dGYg
> PSBOVUxMOw0KPiBAQCAtMTQzLDkgKzE0Myw2IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICph
> cmd2W10pDQo+ICAJCWNhc2UgJ2YnOg0KPiAgCQkJZm9yY2UgPSAxOw0KPiAgCQkJYnJlYWs7DQo+
> IC0JCWNhc2UgJ2MnOg0KPiAtCQkJY2hlY2sgPSAxOw0KPiAtCQkJYnJlYWs7DQo+ICAJCWNhc2Ug
> J3EnOg0KPiAgCQkJcXVpZXQrKzsNCj4gIAkJCWJyZWFrOw0KPiBkaWZmIC0tZ2l0IGEvc2NyaXB0
> cy9kdGMvZmxhdHRyZWUuYyBiL3NjcmlwdHMvZHRjL2ZsYXR0cmVlLmMNCj4gaW5kZXggZWFkMDMz
> Mi4uMjhkMGIyMyAxMDA2NDQNCj4gLS0tIGEvc2NyaXB0cy9kdGMvZmxhdHRyZWUuYw0KPiArKysg
> Yi9zY3JpcHRzL2R0Yy9mbGF0dHJlZS5jDQo+IEBAIC02OTcsNyArNjk3LDYgQEAgc3RhdGljIHN0
> cnVjdCByZXNlcnZlX2luZm8gKmZsYXRfcmVhZF9tZW1fcmVzZXJ2ZShzdHJ1Y3QgaW5idWYgKmlu
> YikNCj4gIHsNCj4gIAlzdHJ1Y3QgcmVzZXJ2ZV9pbmZvICpyZXNlcnZlbGlzdCA9IE5VTEw7DQo+
> ICAJc3RydWN0IHJlc2VydmVfaW5mbyAqbmV3Ow0KPiAtCWNvbnN0IGNoYXIgKnA7DQo+ICAJc3Ry
> dWN0IGZkdF9yZXNlcnZlX2VudHJ5IHJlOw0KPiANCj4gIAkvKg0KPiBAQCAtNzA2LDcgKzcwNSw2
> IEBAIHN0YXRpYyBzdHJ1Y3QgcmVzZXJ2ZV9pbmZvICpmbGF0X3JlYWRfbWVtX3Jlc2VydmUoc3Ry
> dWN0IGluYnVmICppbmIpDQo+ICAJICoNCj4gIAkgKiBGaXJzdCBwYXNzLCBjb3VudCBlbnRyaWVz
> Lg0KPiAgCSAqLw0KPiAtCXAgPSBpbmItPnB0cjsNCj4gIAl3aGlsZSAoMSkgew0KPiAgCQlmbGF0
> X3JlYWRfY2h1bmsoaW5iLCAmcmUsIHNpemVvZihyZSkpOw0KPiAgCQlyZS5hZGRyZXNzICA9IGZk
> dDY0X3RvX2NwdShyZS5hZGRyZXNzKTsNCj4gLS0NCj4gMS43LjguMg0KDQotLSANCm52cHVibGlj
> DQoNCg==

Yeah, that issue has been fixed in the main DTC repo already.

jdl


PS -- No point.  Nope.
