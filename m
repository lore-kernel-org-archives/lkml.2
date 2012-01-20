Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2ATGO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 01:14:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5300 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2ATGOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 01:14:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jan 2012 22:14:10 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "joerg.roedel@amd.com" <joerg.roedel@amd.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "b08248@gmail.com" <b08248@gmail.com>,
        "scottwood@freescale.com" <scottwood@freescale.com>
Date: Fri, 20 Jan 2012 07:14:03 +0100
Subject: Re: [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
Thread-Topic: [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
Thread-Index: AczXOre8ou2aRyLaSP+Tz/S52T25Tw==
Message-ID: <20120120.081403.2268989617582455160.hdoyu@nvidia.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_003_201201200814032268989617582455160hdoyunvidiacom_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_003_201201200814032268989617582455160hdoyunvidiacom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

From: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 0/5] IOMMU: Make IOMMU-API ready for GART-like hardware
Date: Thu, 19 Jan 2012 15:30:00 +0100
Message-ID: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>

> Hi,
>=20
> this patch-set adds two new functions the the IOMMU-API:
>=20
> 	* iommu_domain_set_attr()
> 	* iommu_domain_get_attr()
>=20
> These are generic functions to set and change attributes of a domain.
> The plan is to have a set of generic attributes implemented by more than
> one IOMMU driver as well as driver specific ones. As an example for the
> first type this patch-set also implements the DOMAIN_ATTR_GEOMETRY
> attribute. It can be used to query information about the address space
> window that can be remapped by the iommu hardware. With this attribute
> is is very easy to support IOMMUs like GART and friends.

For Tegra GART & SMMU, this info is passed from board files as
resource data via "platform_get_resource(,IORESOURCE_MEM,)". I think
that this could be the attachement patch in Tegra case. The attached
patches are based on the following post.

https://lkml.org/lkml/2012/1/5/26
https://lkml.org/lkml/2012/1/5/27

--_003_201201200814032268989617582455160hdoyunvidiacom_
Content-Type: text/x-patch;
	name="0001-iommu-tegra-gart-Implement-DOMAIN_ATTR_GEOMETRY-attr.patch"
Content-Description: 0001-iommu-tegra-gart-Implement-DOMAIN_ATTR_GEOMETRY-attr.patch
Content-Disposition: attachment;
	filename="0001-iommu-tegra-gart-Implement-DOMAIN_ATTR_GEOMETRY-attr.patch";
	size=1059; creation-date="Fri, 20 Jan 2012 06:14:07 GMT";
	modification-date="Fri, 20 Jan 2012 06:14:07 GMT"
Content-Transfer-Encoding: base64

RnJvbSA4MmQwZjgwOGE2YWIwYjhjZTM4Mzc5NDVmNTNkOWVmMDQyYjVkYWNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSGlyb3NoaSBET1lVIDxoZG95dUBudmlkaWEuY29tPg0KRGF0
ZTogRnJpLCAyMCBKYW4gMjAxMiAwNzo1NjowNyArMDIwMA0KU3ViamVjdDogW1BBVENIIDEvMl0g
aW9tbXUvdGVncmEvZ2FydDogSW1wbGVtZW50IERPTUFJTl9BVFRSX0dFT01FVFJZDQogYXR0cmli
dXRlDQoNCkltcGxlbWVudCB0aGUgYXR0cmlidXRlIGZvciB0aGUgVGVncmEgR0FSVCBkcml2ZXIu
DQoNClNpZ25lZC1vZmYtYnk6IEhpcm9zaGkgRE9ZVSA8aGRveXVAbnZpZGlhLmNvbT4NCi0tLQ0K
IGRyaXZlcnMvaW9tbXUvdGVncmEtZ2FydC5jIHwgICAgNiArKysrKysNCiAxIGZpbGVzIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvaW9tbXUvdGVncmEtZ2FydC5jIGIvZHJpdmVycy9pb21tdS90ZWdyYS1nYXJ0LmMNCmluZGV4
IGZlYWNjZDQuLmUyMzdiMDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lvbW11L3RlZ3JhLWdhcnQu
Yw0KKysrIGIvZHJpdmVycy9pb21tdS90ZWdyYS1nYXJ0LmMNCkBAIC0xODEsNiArMTgxLDEyIEBA
IHN0YXRpYyBpbnQgZ2FydF9pb21tdV9hdHRhY2hfZGV2KHN0cnVjdCBpb21tdV9kb21haW4gKmRv
bWFpbiwNCiAJaWYgKCFnYXJ0KQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQogCWRvbWFpbi0+cHJpdiA9
IGdhcnQ7DQorDQorCWRvbWFpbi0+Z2VvbWV0cnkuYXBlcnR1cmVfc3RhcnQgPSBnYXJ0LT5pb3Zt
bV9iYXNlOw0KKwlkb21haW4tPmdlb21ldHJ5LmFwZXJ0dXJlX2VuZCAgID0gZ2FydC0+aW92bW1f
YmFzZSArDQorCQlnYXJ0LT5wYWdlX2NvdW50ICogR0FSVF9QQUdFX1NJWkUgLSAxOw0KKwlkb21h
aW4tPmdlb21ldHJ5LmZvcmNlX2FwZXJ0dXJlID0gdHJ1ZTsNCisNCiAJY2xpZW50ID0gZGV2bV9r
emFsbG9jKGRldiwgc2l6ZW9mKCpjKSwgR0ZQX0tFUk5FTCk7DQogCWlmICghY2xpZW50KQ0KIAkJ
cmV0dXJuIC1FTk9NRU07DQotLSANCjEuNy41LjQNCg0K

--_003_201201200814032268989617582455160hdoyunvidiacom_
Content-Type: text/x-patch;
	name="0002-iommu-tegra-smmu-Implement-DOMAIN_ATTR_GEOMETRY-attr.patch"
Content-Description: 0002-iommu-tegra-smmu-Implement-DOMAIN_ATTR_GEOMETRY-attr.patch
Content-Disposition: attachment;
	filename="0002-iommu-tegra-smmu-Implement-DOMAIN_ATTR_GEOMETRY-attr.patch";
	size=984; creation-date="Fri, 20 Jan 2012 06:14:07 GMT";
	modification-date="Fri, 20 Jan 2012 06:14:07 GMT"
Content-Transfer-Encoding: base64

RnJvbSAwNDM4ODg1MzIxM2I4OWVhZTI5YzkxMzhlYjUzMzU5YWJhNmRlMThlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogSGlyb3NoaSBET1lVIDxoZG95dUBudmlkaWEuY29tPg0KRGF0
ZTogRnJpLCAyMCBKYW4gMjAxMiAwODowMjo1NCArMDIwMA0KU3ViamVjdDogW1BBVENIIDIvMl0g
aW9tbXUvdGVncmEvc21tdTogSW1wbGVtZW50IERPTUFJTl9BVFRSX0dFT01FVFJZDQogYXR0cmli
dXRlDQoNCkltcGxlbWVudCB0aGUgYXR0cmlidXRlIGZvciB0aGUgVGVncmEgU01NVSBkcml2ZXIu
DQoNClNpZ25lZC1vZmYtYnk6IEhpcm9zaGkgRE9ZVSA8aGRveXVAbnZpZGlhLmNvbT4NCi0tLQ0K
IGRyaXZlcnMvaW9tbXUvdGVncmEtc21tdS5jIHwgICAgNiArKysrKysNCiAxIGZpbGVzIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvaW9tbXUvdGVncmEtc21tdS5jIGIvZHJpdmVycy9pb21tdS90ZWdyYS1zbW11LmMNCmluZGV4
IDdkZWVhMzIuLjg0NTA0ZmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL2lvbW11L3RlZ3JhLXNtbXUu
Yw0KKysrIGIvZHJpdmVycy9pb21tdS90ZWdyYS1zbW11LmMNCkBAIC03MjMsNiArNzIzLDEyIEBA
IGZvdW5kOg0KIA0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZhcy0+bG9jaywgZmxhZ3MpOw0K
IAlkb21haW4tPnByaXYgPSBhczsNCisNCisJZG9tYWluLT5nZW9tZXRyeS5hcGVydHVyZV9zdGFy
dCA9IHNtbXUtPmlvdm1tX2Jhc2U7DQorCWRvbWFpbi0+Z2VvbWV0cnkuYXBlcnR1cmVfZW5kICAg
PSBzbW11LT5pb3ZtbV9iYXNlICsNCisJCXNtbXUtPnBhZ2VfY291bnQgKiBTTU1VX1BBR0VfU0la
RSAtIDE7DQorCWRvbWFpbi0+Z2VvbWV0cnkuZm9yY2VfYXBlcnR1cmUgPSB0cnVlOw0KKw0KIAlk
ZXZfZGJnKHNtbXUtPmRldiwgInNtbXVfYXNAJXBcbiIsIGFzKTsNCiAJcmV0dXJuIDA7DQogDQot
LSANCjEuNy41LjQNCg0K

--_003_201201200814032268989617582455160hdoyunvidiacom_--
