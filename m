Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1GFI73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab1GFI72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:59:28 -0400
Message-ID: <4E1423E2.8090706@redhat.com>
Date: Wed, 06 Jul 2011 16:59:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Patch] powerpc: fix build errors due to the movement of reboot events
References: <20110701151931.4c2d78b5.sfr@canb.auug.org.au>	<4E0D5BD4.6080403@redhat.com>	<20110701170843.bd60e326.sfr@canb.auug.org.au>	<4E0D9D16.7020508@redhat.com> <20110701203702.a15ecf19.sfr@canb.auug.org.au>
In-Reply-To: <20110701203702.a15ecf19.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------080901030600010909000309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080901030600010909000309
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, Andrew,

Please fold this patch into notifiers-sys-move-reboot-notifiers-into-rebooth.patch.

With this patch applied, make allyesconfig succeeds on ppc64.

Signed-off-by: WANG Cong <amwang@redhat.com>

Thanks!

--------------080901030600010909000309
Content-Type: text/plain;
 name="ppc-build-fix.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ppc-build-fix.diff"

ZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9rZXJuZWwvcnRhcy5jIGIvYXJjaC9wb3dlcnBj
L2tlcm5lbC9ydGFzLmMKaW5kZXggMjcxZmY2My4uMGUwZWE5NCAxMDA2NDQKLS0tIGEvYXJj
aC9wb3dlcnBjL2tlcm5lbC9ydGFzLmMKKysrIGIvYXJjaC9wb3dlcnBjL2tlcm5lbC9ydGFz
LmMKQEAgLTI0LDYgKzI0LDcgQEAKICNpbmNsdWRlIDxsaW51eC9jcHVtYXNrLmg+CiAjaW5j
bHVkZSA8bGludXgvbWVtYmxvY2suaD4KICNpbmNsdWRlIDxsaW51eC9zbGFiLmg+CisjaW5j
bHVkZSA8bGludXgvcmVib290Lmg+CiAKICNpbmNsdWRlIDxhc20vcHJvbS5oPgogI2luY2x1
ZGUgPGFzbS9ydGFzLmg+CmRpZmYgLS1naXQgYS9hcmNoL3Bvd2VycGMva2VybmVsL3J0YXNf
Zmxhc2guYyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvcnRhc19mbGFzaC5jCmluZGV4IGJmNWY1
Y2UuLmUwMzdjNzQgMTAwNjQ0Ci0tLSBhL2FyY2gvcG93ZXJwYy9rZXJuZWwvcnRhc19mbGFz
aC5jCisrKyBiL2FyY2gvcG93ZXJwYy9rZXJuZWwvcnRhc19mbGFzaC5jCkBAIC0xNyw2ICsx
Nyw3IEBACiAjaW5jbHVkZSA8bGludXgvaW5pdC5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIu
aD4KICNpbmNsdWRlIDxsaW51eC9wcm9jX2ZzLmg+CisjaW5jbHVkZSA8bGludXgvcmVib290
Lmg+CiAjaW5jbHVkZSA8YXNtL2RlbGF5Lmg+CiAjaW5jbHVkZSA8YXNtL3VhY2Nlc3MuaD4K
ICNpbmNsdWRlIDxhc20vcnRhcy5oPgo=
--------------080901030600010909000309--
