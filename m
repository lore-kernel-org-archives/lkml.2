Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab1CXI3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:29:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58222 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677Ab1CXI3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dVrW+4ykLBsEl22byN1JBIIy/VYSHIsFGi3G7HNhMUJQr05dNm3piS7Z+nfwxoqNFk
         3yEh+3O/T/6Uk4BLLg/c+d69j6g/zynKbgVbWJQXlwV/YKE6T0KnNqp8k9mWvb8hqzib
         0blsx9PJAqsv1cLNNBo1Wag9ow3eQ8+SCg8rs=
MIME-Version: 1.0
Date: Thu, 24 Mar 2011 11:29:43 +0300
Message-ID: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com>
Subject: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter before test
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf301fc0c37c4c10049f364774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf301fc0c37c4c10049f364774
Content-Type: text/plain; charset=ISO-8859-1

Don, I've added yours SOB, ok? (The patch is attached to avoid
space/tabs problem
due to web-mail client)

--20cf301fc0c37c4c10049f364774
Content-Type: application/octet-stream; name=perf-x86-p4-pmu-unflagged
Content-Disposition: attachment; filename=perf-x86-p4-pmu-unflagged
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glnf422b0

RnJvbTogRG9uIFppY2t1cyA8ZHppY2t1c0ByZWRoYXQuY29tPgpTdWJqZWN0OiBbUEFUQ0ggLXRp
cF0gcGVyZiwgeDg2OiBQNCBQTVUgLSBBZGQgbWlzc2luZyByZWFkIG9mIGEgY291bnRlciBiZWZv
cmUgdGVzdAoKVGhlIHJlYWQgb2YgcmVhbCBNU1IgcmVnaXN0ZXIgd2FzIG1pc3NlZCBiZWZvcmUK
aWYgKCkgY2xhdXNlIHdoaWNoIGxlYWRzIHRoYXQgdGVzdCBuZXZlciBzdWNjZXNzLgoKU2lnbmVk
LW9mZi1ieTogRG9uIFppY2t1cyA8ZHppY2t1c0ByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBD
eXJpbGwgR29yY3Vub3YgPGdvcmN1bm92QG9wZW52ei5vcmc+Ci0tLQogYXJjaC94ODYva2VybmVs
L2NwdS9wZXJmX2V2ZW50X3A0LmMgfCAgICAxICsKIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKQoKSW5kZXg6IGxpbnV4LTIuNi50aXAvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50
X3A0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LnRpcC5vcmlnL2FyY2gveDg2L2tlcm5lbC9j
cHUvcGVyZl9ldmVudF9wNC5jCisrKyBsaW51eC0yLjYudGlwL2FyY2gveDg2L2tlcm5lbC9jcHUv
cGVyZl9ldmVudF9wNC5jCkBAIC03NzcsNiArNzc3LDcgQEAgc3RhdGljIGlubGluZSBpbnQgcDRf
cG11X2NsZWFyX2NjY3Jfb3ZmKAogCSAqIHRoZSBjb3VudGVyIGhhcyByZWFjaGVkIHplcm8gdmFs
dWUgYW5kIGNvbnRpbnVlZCBjb3VudGluZyBiZWZvcmUKIAkgKiByZWFsIE5NSSBzaWduYWwgd2Fz
IHJlY2VpdmVkOgogCSAqLworCXJkbXNybChod2MtPmV2ZW50X2Jhc2UsIHYpOwogCWlmICghKHYg
JiBBUkNIX1A0X1VORkxBR0dFRF9CSVQpKQogCQlyZXR1cm4gMTsKIAo=
--20cf301fc0c37c4c10049f364774--
