Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0LHKjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:39:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32854 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0LHKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=lfD8Cjw/WOQyuESMkCI5hR/9M/+jbZb/H0QmjLPBVyMZGY5PFrOtjPFjNJhQn4BI0B
         P1FqIRsFBriAA58T+3Mxsj6wS8fVFFGGt758a0hd8oZV04YjAf4qOKbVVPN2lX6AEywq
         GTGgpKKowCV1cQQcwuJiUBs5ovh1KcmXpc60Y=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 8 Dec 2010 11:39:30 +0100
Message-ID: <AANLkTinbinQjvXo58hKDY4ZaMe1ZrGqWDbhoxdS+JLOG@mail.gmail.com>
Subject: [PATCH] platform/x86: Kconfig: Replace select by depends on ACPI_WMI
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: multipart/mixed; boundary=0016363b852076b1950496e3bc78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363b852076b1950496e3bc78
Content-Type: text/plain; charset=UTF-8

This patch for linux-next fixes several warnings in
platform/x86/Kconfig doing a "make oldnoconfig" (for Details please
see attached patch).

- Sedat -

--0016363b852076b1950496e3bc78
Content-Type: plain/text; 
	name="0001-platform-x86-Kconfig-Replace-select-by-depends-on-AC.patch"
Content-Disposition: attachment; 
	filename="0001-platform-x86-Kconfig-Replace-select-by-depends-on-AC.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghg363sr0

RnJvbSAyNjM2YTFhODI2ODU0YWQ2YmQwN2M2OGUyYTI5OWJkNjNlNGJmZmIxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDggRGVjIDIwMTAgMTE6MjA6MjYgKzAxMDAKU3ViamVjdDogW1BBVENIXSBwbGF0
Zm9ybS94ODY6IEtjb25maWc6IFJlcGxhY2Ugc2VsZWN0IGJ5IGRlcGVuZHMgb24gQUNQSV9XTUkK
CldpdGggJ21ha2Ugb2xkbm9jb25maWcnIEkgc2VlIHRoZXNlIHdhcm5pbmdzIGluIGxpbnV4LW5l
eHQgKG5leHQtMjAxMDEyMDgpOgoKZHJpdmVycy9wbGF0Zm9ybS94ODYvS2NvbmZpZzo0MjI6ZXJy
b3I6IHJlY3Vyc2l2ZSBkZXBlbmRlbmN5IGRldGVjdGVkIQpkcml2ZXJzL3BsYXRmb3JtL3g4Ni9L
Y29uZmlnOjQyMjogICAgICAgc3ltYm9sIEVFRVBDX1dNSSBkZXBlbmRzIG9uIEFDUElfV01JCmRy
aXZlcnMvcGxhdGZvcm0veDg2L0tjb25maWc6NDM4OiAgICAgICBzeW1ib2wgQUNQSV9XTUkgaXMg
c2VsZWN0ZWQgYnkgQUNFUl9XTUkKZHJpdmVycy9wbGF0Zm9ybS94ODYvS2NvbmZpZzoxODogICAg
ICAgIHN5bWJvbCBBQ0VSX1dNSSBkZXBlbmRzIG9uIExFRFNfQ0xBU1MKZHJpdmVycy9sZWRzL0tj
b25maWc6MTA6ICAgICAgICBzeW1ib2wgTEVEU19DTEFTUyBpcyBzZWxlY3RlZCBieSBFRUVQQ19X
TUkKClRoaXMgcGF0Y2ggcmVwbGFjZXMgYWxsICJzZWxlY3Qgb24gQUNQSV9XTUkiIGJ5ICJkZXBl
bmRzIG9uIEFDUElfV01JIi4KClF1b3RlIGZyb20gRGF2aWQgV29vZGhvdXNlOgoiQSBiZXR0ZXIg
cG9saWN5IGlzOiAiTkVWRVIgVVNFIFNFTEVDVCIuIgoKUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTog
U2VkYXQgRGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogU2VkYXQg
RGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL3BsYXRmb3JtL3g4Ni9L
Y29uZmlnIHwgICAgNCArKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3BsYXRmb3JtL3g4Ni9LY29uZmlnIGIv
ZHJpdmVycy9wbGF0Zm9ybS94ODYvS2NvbmZpZwppbmRleCA0YzdmOGI5Li42YTNhNzlkIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3BsYXRmb3JtL3g4Ni9LY29uZmlnCisrKyBiL2RyaXZlcnMvcGxhdGZv
cm0veDg2L0tjb25maWcKQEAgLTIzLDcgKzIzLDcgQEAgY29uZmlnIEFDRVJfV01JCiAJZGVwZW5k
cyBvbiBCQUNLTElHSFRfQ0xBU1NfREVWSUNFCiAJZGVwZW5kcyBvbiBTRVJJT19JODA0MgogCWRl
cGVuZHMgb24gUkZLSUxMIHx8IFJGS0lMTCA9IG4KLQlzZWxlY3QgQUNQSV9XTUkKKwlkZXBlbmRz
IG9uIEFDUElfV01JCiAJLS0taGVscC0tLQogCSAgVGhpcyBpcyBhIGRyaXZlciBmb3IgbmV3ZXIg
QWNlciAoYW5kIFdpc3Ryb24pIGxhcHRvcHMuIEl0IGFkZHMKIAkgIHdpcmVsZXNzIHJhZGlvIGFu
ZCBibHVldG9vdGggY29udHJvbCwgYW5kIG9uIHNvbWUgbGFwdG9wcywKQEAgLTEzMSw3ICsxMzEs
NyBAQCBjb25maWcgVEMxMTAwX1dNSQogCWRlcGVuZHMgb24gIVg4Nl82NAogCWRlcGVuZHMgb24g
RVhQRVJJTUVOVEFMCiAJZGVwZW5kcyBvbiBBQ1BJCi0Jc2VsZWN0IEFDUElfV01JCisJZGVwZW5k
cyBvbiBBQ1BJX1dNSQogCS0tLWhlbHAtLS0KIAkgIFRoaXMgaXMgYSBkcml2ZXIgZm9yIHRoZSBX
TUkgZXh0ZW5zaW9ucyAod2lyZWxlc3MgYW5kIGJsdWV0b290aCBwb3dlcgogCSAgY29udHJvbCkg
b2YgdGhlIEhQIENvbXBhcSBUQzExMDAgdGFibGV0LgotLSAKMS43LjIuMwoK
--0016363b852076b1950496e3bc78--
