Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab2GGLfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 07:35:37 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45470 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2GGLfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 07:35:36 -0400
MIME-Version: 1.0
In-Reply-To: <CACV3sbKHdzYEwap2r_o+4ccYAZU67qPkBYgQwNv3paDq8WJrnQ@mail.gmail.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
	<4E527684.3020206@draigBrady.com>
	<20110822161914.GA9399@redhat.com>
	<CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com>
	<20110824110134.GA17362@hmsreliant.think-freely.org>
	<CACV3sbKHdzYEwap2r_o+4ccYAZU67qPkBYgQwNv3paDq8WJrnQ@mail.gmail.com>
Date: Sat, 7 Jul 2012 19:35:34 +0800
Message-ID: <CACV3sb+Ty_VCdn5-Z-rFAsNxTk2wsw0n7atqhNZGWgqwb1TsYA@mail.gmail.com>
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
From: Jovi Zhang <bookjovi@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>, akpm@linux-foundation.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, dhowells@redhat.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6de16fa73b5a004c43bc7c1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6de16fa73b5a004c43bc7c1
Content-Type: text/plain; charset=UTF-8

Hi Andrew,

Is that attached patch ok to go through your -mm tree? this patch
reviewed many months ago, but still not goto mainstream. :)

that comments is quite mismatch with the code.

Thanks.

.jovi

--0016e6de16fa73b5a004c43bc7c1
Content-Type: application/octet-stream; 
	name="0001-coredump-fix-wrong-comments-on-core-limits-of-pipe-c.patch"
Content-Disposition: attachment; 
	filename="0001-coredump-fix-wrong-comments-on-core-limits-of-pipe-c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4cm92tk0

RnJvbSBkYzdiMDJhMWUwZTQxM2ZiOTZkMjJmMWQ0ZWY0ZGE5ODExNWNmYjlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMTcgQXVnIDIwMTEgMTU6MzQ6MjkgKzA4MDAKU3ViamVjdDogW1BBVENIXSBjb3JlZHVt
cDogZml4IHdyb25nIGNvbW1lbnRzIG9uIGNvcmUgbGltaXRzIG9mIHBpcGUgY29yZWR1bXAgY2Fz
ZQoKSW4gY29tbWl0IDg5OGIzNzRhLCBjb3JlIGxpbWl0cyByZWN1cnNpdmUgY2hlY2sgdmF1bGUg
Y2hhbmdlZCBmcm9tIDAgdG8gMSwKYnV0IHRoZSBjb3JyZXNwb25kaW5nIGNvbW1lbnRzIHdhcyBu
b3QgY2hhbmdlZCBjb3JyZWN0bHkuCgpTaWduZWQtb2ZmLWJ5OiBKb3ZpIFpoYW5nIDxib29ram92
aUBnbWFpbC5jb20+CkNjOiBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+CkNjOiBOZWls
IEhvcm1hbiA8bmhvcm1hbkB0dXhkcml2ZXIuY29tPgotLS0KIGZzL2V4ZWMuYyB8ICAgMTUgKysr
KysrKystLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9leGVjLmMgYi9mcy9leGVjLmMKaW5kZXggMjVkY2JlNS4u
YmE0OTNjYyAxMDA2NDQKLS0tIGEvZnMvZXhlYy5jCisrKyBiL2ZzL2V4ZWMuYwpAQCAtMjE1OCwx
NSArMjE1OCwxNiBAQCB2b2lkIGRvX2NvcmVkdW1wKGxvbmcgc2lnbnIsIGludCBleGl0X2NvZGUs
IHN0cnVjdCBwdF9yZWdzICpyZWdzKQogCQl9CiAKIAkJaWYgKGNwcm0ubGltaXQgPT0gMSkgewot
CQkJLyoKKwkJCS8qIFNlZSB1bWhfcGlwZV9zZXR1cCgpIHdoaWNoIHNldHMgUkxJTUlUX0NPUkUg
PSAxLgorCQkJICoKIAkJCSAqIE5vcm1hbGx5IGNvcmUgbGltaXRzIGFyZSBpcnJlbGV2YW50IHRv
IHBpcGVzLCBzaW5jZQogCQkJICogd2UncmUgbm90IHdyaXRpbmcgdG8gdGhlIGZpbGUgc3lzdGVt
LCBidXQgd2UgdXNlCi0JCQkgKiBjcHJtLmxpbWl0IG9mIDEgaGVyZSBhcyBhIHNwZWFjaWFsIHZh
bHVlLiBBbnkKLQkJCSAqIG5vbi0xIGxpbWl0IGdldHMgc2V0IHRvIFJMSU1fSU5GSU5JVFkgYmVs
b3csIGJ1dAotCQkJICogYSBsaW1pdCBvZiAwIHNraXBzIHRoZSBkdW1wLiAgVGhpcyBpcyBhIGNv
bnNpc3RlbnQKLQkJCSAqIHdheSB0byBjYXRjaCByZWN1cnNpdmUgY3Jhc2hlcy4gIFdlIGNhbiBz
dGlsbCBjcmFzaAotCQkJICogaWYgdGhlIGNvcmVfcGF0dGVybiBiaW5hcnkgc2V0cyBSTElNX0NP
UkUgPSAgITEKLQkJCSAqIGJ1dCBpdCBydW5zIGFzIHJvb3QsIGFuZCBjYW4gZG8gbG90cyBvZiBz
dHVwaWQgdGhpbmdzCisJCQkgKiBjcHJtLmxpbWl0IG9mIDEgaGVyZSBhcyBhIHNwZWFjaWFsIHZh
bHVlLCB0aGlzIGlzIGEKKwkJCSAqIGNvbnNpc3RlbnQgd2F5IHRvIGNhdGNoIHJlY3Vyc2l2ZSBj
cmFzaGVzLgorCQkJICogV2UgY2FuIHN0aWxsIGNyYXNoIGlmIHRoZSBjb3JlX3BhdHRlcm4gYmlu
YXJ5IHNldHMKKwkJCSAqIFJMSU1fQ09SRSA9ICExLCBidXQgaXQgcnVucyBhcyByb290LCBhbmQg
Y2FuIGRvCisJCQkgKiBsb3RzIG9mIHN0dXBpZCB0aGluZ3MuCisJCQkgKgogCQkJICogTm90ZSB0
aGF0IHdlIHVzZSB0YXNrX3RnaWRfdm5yIGhlcmUgdG8gZ3JhYiB0aGUgcGlkCiAJCQkgKiBvZiB0
aGUgcHJvY2VzcyBncm91cCBsZWFkZXIuICBUaGF0IHdheSB3ZSBnZXQgdGhlCiAJCQkgKiByaWdo
dCBwaWQgaWYgYSB0aHJlYWQgaW4gYSBtdWx0aS10aHJlYWRlZAotLSAKMS42LjUuMgoK
--0016e6de16fa73b5a004c43bc7c1--
