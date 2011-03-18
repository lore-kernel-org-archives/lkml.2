Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1CRIHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:07:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43667 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab1CRIHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:07:01 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.76.183]
In-Reply-To: <20110318070935.GC3555@atomide.com>
References: <20110317183048.GW7258@atomide.com> <AANLkTik_Y1uMfVTVVEdPFG0sjW2uYpeeUMKfymho3sd+@mail.gmail.com>
 <20110318070935.GC3555@atomide.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 18 Mar 2011 10:06:41 +0200
Message-ID: <AANLkTin-dwhmFjF=g90tMvGMS1hv-cod9WrQiaLfYygS@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d2722740c2ce049ebd4387
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d2722740c2ce049ebd4387
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Mar 18, 2011 at 9:09 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> [110317 20:00]:
>> Make platforms that need it "select" it or something. It looks like
>> nobody but an OMAP4 could _possibly_ ever want to answer 'y' to that
>> question, SO DON'T ASK IT!
>
> No problem, let's make it depends on OMAP4.

(patch also attached in case gmail eats my whitespace)


>From d086e8f994b9272f8c999af0a4d32d870749c77a Mon Sep 17 00:00:00 2001
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 18 Mar 2011 10:01:11 +0200
Subject: [PATCH] hwspinlock: depend on OMAP4

Currently only OMAP4 supports hwspinlocks, so don't bother asking
anyone else.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/hwspinlock/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
index eb4af28..1f29bab 100644
--- a/drivers/hwspinlock/Kconfig
+++ b/drivers/hwspinlock/Kconfig
@@ -4,6 +4,7 @@

 config HWSPINLOCK
 	tristate "Generic Hardware Spinlock framework"
+	depends on ARCH_OMAP4
 	help
 	  Say y here to support the generic hardware spinlock framework.
 	  You only need to enable this if you have hardware spinlock module
-- 
1.7.1

--0016e6d2722740c2ce049ebd4387
Content-Type: text/x-patch; charset=US-ASCII; name="0001-hwspinlock-depend-on-OMAP4.patch"
Content-Disposition: attachment; 
	filename="0001-hwspinlock-depend-on-OMAP4.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gletqugf0

RnJvbSBkMDg2ZThmOTk0YjkyNzJmOGM5OTlhZjBhNGQzMmQ4NzA3NDljNzdhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPaGFkIEJlbi1Db2hlbiA8b2hhZEB3aXplcnkuY29tPgpEYXRl
OiBGcmksIDE4IE1hciAyMDExIDEwOjAxOjExICswMjAwClN1YmplY3Q6IFtQQVRDSF0gaHdzcGlu
bG9jazogZGVwZW5kIG9uIE9NQVA0CgpDdXJyZW50bHkgb25seSBPTUFQNCBzdXBwb3J0cyBod3Nw
aW5sb2Nrcywgc28gZG9uJ3QgYm90aGVyIGFza2luZwphbnlvbmUgZWxzZS4KClNpZ25lZC1vZmYt
Ynk6IE9oYWQgQmVuLUNvaGVuIDxvaGFkQHdpemVyeS5jb20+Ci0tLQogZHJpdmVycy9od3NwaW5s
b2NrL0tjb25maWcgfCAgICAxICsKIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAw
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvaHdzcGlubG9jay9LY29uZmlnIGIv
ZHJpdmVycy9od3NwaW5sb2NrL0tjb25maWcKaW5kZXggZWI0YWYyOC4uMWYyOWJhYiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9od3NwaW5sb2NrL0tjb25maWcKKysrIGIvZHJpdmVycy9od3NwaW5sb2Nr
L0tjb25maWcKQEAgLTQsNiArNCw3IEBACiAKIGNvbmZpZyBIV1NQSU5MT0NLCiAJdHJpc3RhdGUg
IkdlbmVyaWMgSGFyZHdhcmUgU3BpbmxvY2sgZnJhbWV3b3JrIgorCWRlcGVuZHMgb24gQVJDSF9P
TUFQNAogCWhlbHAKIAkgIFNheSB5IGhlcmUgdG8gc3VwcG9ydCB0aGUgZ2VuZXJpYyBoYXJkd2Fy
ZSBzcGlubG9jayBmcmFtZXdvcmsuCiAJICBZb3Ugb25seSBuZWVkIHRvIGVuYWJsZSB0aGlzIGlm
IHlvdSBoYXZlIGhhcmR3YXJlIHNwaW5sb2NrIG1vZHVsZQotLSAKMS43LjEKCg==
--0016e6d2722740c2ce049ebd4387--
