Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1HDBFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:05:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab1HDBE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:04:56 -0400
MIME-Version: 1.0
In-Reply-To: <049cae3c2e2923ea7efbd205257e9e22b3df5e1a.1312388919.git.dmitry.kasatkin@intel.com>
References: <049cae3c2e2923ea7efbd205257e9e22b3df5e1a.1312388919.git.dmitry.kasatkin@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Aug 2011 15:04:34 -1000
Message-ID: <CA+55aFzdMiyXiPrBfwW6Ra0P6qtJXf4MYRLB7NvkQdkerSzrUA@mail.gmail.com>
Subject: Re: [PATCH 1/1] xen: asm/io.h should not include xen.h if XEN is disabled
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00504502d30a959ad304a9a3916a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504502d30a959ad304a9a3916a
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Aug 3, 2011 at 6:33 AM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
>
> XEN related content is behind the CONFIG_XEN flag in the io.h.
> And <xen/xen.h> should be also behind CONFIG_XEN flag.

Wouldn't it be much nicer to just move the '#include <xen/xen.h>' line down?

Does the attached patch work for you?

              Linus

--00504502d30a959ad304a9a3916a
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqx0w2l50

IGFyY2gveDg2L2luY2x1ZGUvYXNtL2lvLmggfCAgICAzICstLQogMSBmaWxlcyBjaGFuZ2VkLCAx
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5j
bHVkZS9hc20vaW8uaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2lvLmgKaW5kZXggZDAyODA0ZDY1
MGM0Li5kOGU4ZWVmYmUyNGMgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2lvLmgK
KysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vaW8uaApAQCAtNDAsOCArNDAsNiBAQAogI2luY2x1
ZGUgPGxpbnV4L2NvbXBpbGVyLmg+CiAjaW5jbHVkZSA8YXNtL3BhZ2UuaD4KIAotI2luY2x1ZGUg
PHhlbi94ZW4uaD4KLQogI2RlZmluZSBidWlsZF9tbWlvX3JlYWQobmFtZSwgc2l6ZSwgdHlwZSwg
cmVnLCBiYXJyaWVyKSBcCiBzdGF0aWMgaW5saW5lIHR5cGUgbmFtZShjb25zdCB2b2xhdGlsZSB2
b2lkIF9faW9tZW0gKmFkZHIpIFwKIHsgdHlwZSByZXQ7IGFzbSB2b2xhdGlsZSgibW92IiBzaXpl
ICIgJTEsJTAiOnJlZyAocmV0KSBcCkBAIC0zMzQsNiArMzMyLDcgQEAgZXh0ZXJuIHZvaWQgZml4
dXBfZWFybHlfaW9yZW1hcCh2b2lkKTsKIGV4dGVybiBib29sIGlzX2Vhcmx5X2lvcmVtYXBfcHRl
cChwdGVfdCAqcHRlcCk7CiAKICNpZmRlZiBDT05GSUdfWEVOCisjaW5jbHVkZSA8eGVuL3hlbi5o
Pgogc3RydWN0IGJpb192ZWM7CiAKIGV4dGVybiBib29sIHhlbl9iaW92ZWNfcGh5c19tZXJnZWFi
bGUoY29uc3Qgc3RydWN0IGJpb192ZWMgKnZlYzEsCg==
--00504502d30a959ad304a9a3916a--
