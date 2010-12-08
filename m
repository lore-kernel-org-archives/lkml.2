Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0LHNi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:38:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44078 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab0LHNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=UMYJczqMlw/XdBAHxZUD181o8UpjZdEjll8u7TBKEbJ+ehEwn12jmzeOiD0Kvqspyh
         e6mnn6VQUS5vdTvQ0tzHuviqGEkHIgTre92qeJ6km36pOFF0xGrKdYWwd9mk48/9Ze3U
         VwGe/Agu/Nz4Q/6vUcXgHsM5L8FAwovZHJraI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 8 Dec 2010 14:38:23 +0100
Message-ID: <AANLkTim0-EY8z6_XYG9ZGc3RnK7v8Du4njygsH62Wc5M@mail.gmail.com>
Subject: [PATCH] speakup: fakekey.c: Fix error: macro "__this_cpu_write"
 requires 2 arguments, but only 1 given
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Neil Horman <nhorman@tuxdriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: multipart/mixed; boundary=00163631028b3a20600496e63c3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163631028b3a20600496e63c3f
Content-Type: text/plain; charset=UTF-8

While building linux-next (next-20101208) I fell over this build failure.
The attached patch is compile-tested-only.

- Sedat -

--00163631028b3a20600496e63c3f
Content-Type: text/x-diff; charset=UTF-8; 
	name="0001-speakup-fakekey.c-Fix-error-macro-__this_cpu_write-r.patch"
Content-Disposition: attachment; 
	filename="0001-speakup-fakekey.c-Fix-error-macro-__this_cpu_write-r.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghg9k7cn0

RnJvbSA0ZjI1ZGU4NWQyOWZhMzI3NTFjODc5ZTY0NTI2OTExOWEzZWYzNTc5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDggRGVjIDIwMTAgMTQ6MjI6NDkgKzAxMDAKU3ViamVjdDogW1BBVENIXSBzcGVh
a3VwOmZha2VrZXkuYzogRml4IGVycm9yOiBtYWNybyAiX190aGlzX2NwdV93cml0ZSIgcmVxdWly
ZXMgMiBhcmd1bWVudHMsIGJ1dCBvbmx5IDEgZ2l2ZW4KTUlNRS1WZXJzaW9uOiAxLjAKQ29udGVu
dC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rp
bmc6IDhiaXQKCkZyb20gYnVpbGQubG9nOgoKZHJpdmVycy9zdGFnaW5nL3NwZWFrdXAvZmFrZWtl
eS5jOjgxOjM4OiBlcnJvcjogbWFjcm8gIl9fdGhpc19jcHVfd3JpdGUiIHJlcXVpcmVzIDIgYXJn
dW1lbnRzLCBidXQgb25seSAxIGdpdmVuCmRyaXZlcnMvc3RhZ2luZy9zcGVha3VwL2Zha2VrZXku
YzogSW4gZnVuY3Rpb24g4oCYc3BlYWt1cF9mYWtlX2Rvd25fYXJyb3figJk6CmRyaXZlcnMvc3Rh
Z2luZy9zcGVha3VwL2Zha2VrZXkuYzo4MTogZXJyb3I6IOKAmF9fdGhpc19jcHVfd3JpdGXigJkg
dW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pCmRyaXZlcnMvc3RhZ2luZy9z
cGVha3VwL2Zha2VrZXkuYzo4MTogZXJyb3I6IChFYWNoIHVuZGVjbGFyZWQgaWRlbnRpZmllciBp
cyByZXBvcnRlZCBvbmx5IG9uY2UKZHJpdmVycy9zdGFnaW5nL3NwZWFrdXAvZmFrZWtleS5jOjgx
OiBlcnJvcjogZm9yIGVhY2ggZnVuY3Rpb24gaXQgYXBwZWFycyBpbi4pCmRyaXZlcnMvc3RhZ2lu
Zy9zcGVha3VwL2Zha2VrZXkuYzo4MTogd2FybmluZzogbGVmdC1oYW5kIG9wZXJhbmQgb2YgY29t
bWEgZXhwcmVzc2lvbiBoYXMgbm8gZWZmZWN0CmRyaXZlcnMvc3RhZ2luZy9zcGVha3VwL2Zha2Vr
ZXkuYzo4MTogd2FybmluZzogc3RhdGVtZW50IHdpdGggbm8gZWZmZWN0CmRyaXZlcnMvc3RhZ2lu
Zy9zcGVha3VwL2Zha2VrZXkuYzo4MTogZXJyb3I6IGV4cGVjdGVkIOKAmDvigJkgYmVmb3JlIOKA
mCnigJkgdG9rZW4KZHJpdmVycy9zdGFnaW5nL3NwZWFrdXAvZmFrZWtleS5jOjgxOiBlcnJvcjog
ZXhwZWN0ZWQgc3RhdGVtZW50IGJlZm9yZSDigJgp4oCZIHRva2VuCgpJc3N1ZSB3YXMgaW50cm9k
dWNlZCBieToKICAgY29tbWl0IDZjOWJmNjAxYjkwOTdmODM4MzliYWVlMDliOWYzZWFhMDk5ZmMz
ZjQKICAgImRyaXZlcnM6IFJlcGxhY2UgX19nZXRfY3B1X3ZhciB3aXRoIF9fdGhpc19jcHVfcmVh
ZCBpZiBub3QgdXNlZCBmb3IgYW4gYWRkcmVzcy4iCgpTaWduZWQtb2ZmLWJ5OiBTZWRhdCBEaWxl
ayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy9zcGVha3VwL2Zh
a2VrZXkuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9zcGVha3VwL2Zha2VrZXku
YyBiL2RyaXZlcnMvc3RhZ2luZy9zcGVha3VwL2Zha2VrZXkuYwppbmRleCA5ZjJhN2ExLi4xYjM0
YTg3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvc3BlYWt1cC9mYWtla2V5LmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3NwZWFrdXAvZmFrZWtleS5jCkBAIC03OCw3ICs3OCw3IEBAIHZvaWQg
c3BlYWt1cF9mYWtlX2Rvd25fYXJyb3codm9pZCkKIAkvKiBkb24ndCBjaGFuZ2UgQ1BVICovCiAJ
cHJlZW1wdF9kaXNhYmxlKCk7CiAKLQlfX3RoaXNfY3B1X3dyaXRlKHJlcG9ydGluZ19rZXlzdHJv
a2UpLCB0cnVlKTsKKwlfX3RoaXNfY3B1X3dyaXRlKHJlcG9ydGluZ19rZXlzdHJva2UsIHRydWUp
OwogCWlucHV0X3JlcG9ydF9rZXkodmlydF9rZXlib2FyZCwgS0VZX0RPV04sIFBSRVNTRUQpOwog
CWlucHV0X3JlcG9ydF9rZXkodmlydF9rZXlib2FyZCwgS0VZX0RPV04sIFJFTEVBU0VEKTsKIAlf
X3RoaXNfY3B1X3dyaXRlKHJlcG9ydGluZ19rZXlzdHJva2UsIGZhbHNlKTsKLS0gCjEuNy4yLjMK
Cg==
--00163631028b3a20600496e63c3f--
