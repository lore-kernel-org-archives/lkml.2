Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1FHKJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:09:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59985 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1FHKJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ar49Y1iDzNbd71oQnpz0yh0t60Hqe7t7JPWE1JmWgKs/aQBtgoEHyK07RtjrGyYsZ2
         RkNzUazQXb66KE9DwfVLxnEKFHXgymj17zHItuHtYoAL/5ur8Tr8v2UnJ5bpOPnBvddq
         wRSAuKAjSXa5lhodqp6y8okvQ3B8w0rhofDKY=
MIME-Version: 1.0
In-Reply-To: <20110608054354.GA1717@x4.trippels.de>
References: <20110608054002.GA1717@x4.trippels.de>
	<20110608054354.GA1717@x4.trippels.de>
Date: Wed, 8 Jun 2011 20:09:33 +1000
Message-ID: <BANLkTinfn82C3TjPxzZuD+v=F+uCx8pmyg@mail.gmail.com>
Subject: Re: Latest merge of 'drm-radeon-fixes' breaks my setup
From: Dave Airlie <airlied@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Airlie <airlied@redhat.com>,
        =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <maraeo@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00151748e0747f587304a5308870
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151748e0747f587304a5308870
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 8, 2011 at 3:43 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2011.06.08 at 07:40 +0200, Markus Trippelsdorf wrote:
>> The merge of the 'drm-radeon' branch by Linus yesterday breaks my setup
>> (RS780). The mouse cursor is just a black block suddenly and I see an
>> endless stream of:
>> =A0radeon 0000:01:05.0: r600_check_texture_resource:1338 texture invalid=
 format 26
>> =A0[drm:radeon_cs_ioctl] *ERROR* Invalid command stream !

This is wierd, can you try the attached patch, it appears this
uncovered another bug.

Dave.

--00151748e0747f587304a5308870
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-set-family-for-use-in-parser.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-set-family-for-use-in-parser.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_goo3ycne0

RnJvbSA4N2ExMzA3NjNlN2ExN2U2MWNjMThhNzI3OWQzMWI1OGI3YmRmNWIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBXZWQsIDggSnVuIDIwMTEgMTk6NTg6MjkgKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm0vcmFk
ZW9uL2ttczogc2V0IGZhbWlseSBmb3IgdXNlIGluIHBhcnNlci4KCldpZXJkbHkgdGhlIGttcyBw
YXJzZXIgbmV2ZXIgaW5pdGlhbGlzZWQgdGhlIGZhbWlseSwgaXQgd2Fzbid0IHJlYWxseSB1c2Vk
Cm11Y2gsIGJ1dCB0aGUgZm10IGNoZWNrZXIgcGF0Y2ggc3RhcnRlZCB1c2luZyBpdCBhbmQgaXQg
ZmVsbCBvdmVyLgoKUmVwb3J0ZWQtYnk6IE1hcmt1cyBUcmlwcGVsc2RvcmYgPG1hcmt1c0B0cmlw
cGVsc2RvcmYuZGU+ClNpZ25lZC1vZmYtYnk6IERhdmUgQWlybGllIDxhaXJsaWVkQHJlZGhhdC5j
b20+Ci0tLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY3MuYyB8ICAgIDEgKwogMSBm
aWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY3MuYyBiL2RyaXZlcnMvZ3B1L2RybS9y
YWRlb24vcmFkZW9uX2NzLmMKaW5kZXggOGMxOTE2OS4uZmFlMDBjMCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY3MuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFk
ZW9uL3JhZGVvbl9jcy5jCkBAIC0yMjgsNiArMjI4LDcgQEAgaW50IHJhZGVvbl9jc19pb2N0bChz
dHJ1Y3QgZHJtX2RldmljZSAqZGV2LCB2b2lkICpkYXRhLCBzdHJ1Y3QgZHJtX2ZpbGUgKmZpbHAp
CiAJcGFyc2VyLmZpbHAgPSBmaWxwOwogCXBhcnNlci5yZGV2ID0gcmRldjsKIAlwYXJzZXIuZGV2
ID0gcmRldi0+ZGV2OworCXBhcnNlci5mYW1pbHkgPSByZGV2LT5mYW1pbHk7CiAJciA9IHJhZGVv
bl9jc19wYXJzZXJfaW5pdCgmcGFyc2VyLCBkYXRhKTsKIAlpZiAocikgewogCQlEUk1fRVJST1Io
IkZhaWxlZCB0byBpbml0aWFsaXplIHBhcnNlciAhXG4iKTsKLS0gCjEuNy41LjIKCg==
--00151748e0747f587304a5308870--
