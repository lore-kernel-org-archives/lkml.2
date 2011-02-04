Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab1BDMRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:17:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43172 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab1BDMR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:17:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ZWraOD9YuVDGKujZcDa9yZnhTKS+tfzsU/xtM2YLBwenztvID03HlchUy/rgh32xnT
         cgH8W3R7SMcs5zhZcA783v38k6yCCPUbe1v8zhU/fRTkt4OvnonSNp+ZMNmdZwBLhj4F
         pTSn5x4JX06ba8th5438TceCTXqcTwCxIHKuk=
MIME-Version: 1.0
Date: Fri, 4 Feb 2011 15:17:28 +0300
Message-ID: <AANLkTin5gCnhVos3Lu_0GZSxFQmvsNEYTO=Jq7UdmYb1@mail.gmail.com>
Subject: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>
Cc: George Spelvin <linux@horizon.com>, Meelis Roos <mroos@linux.ee>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf302078629baeff049b73dd04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf302078629baeff049b73dd04
Content-Type: text/plain; charset=ISO-8859-1

Please apply it, sorry for non-inlined patch (have a web access only at moment).

Note that I've tested the patch on non-HT machine so if someone have HT'ed one
-- it would be great to test the patch there.

Cyrill

--20cf302078629baeff049b73dd04
Content-Type: application/octet-stream; name=x86-perf-unflagged-nmi
Content-Disposition: attachment; filename=x86-perf-unflagged-nmi
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjr21kkt0

RnJvbTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBvcGVudnoub3JnPgpTdWJqZWN0OiBbUEFU
Q0hdIHBlcmYsIHg4NjogUDQgUE1VIC0tIEZpeCB1bmZsYWdnZWQgb3ZlcmZsb3dzIHRlc3QKCkEg
Y291cGxlIG9mIHBlb3BsZSBoYXZlIHJlcG9ydGVkIGFuIHVua25vd24gTk1JIGlzc3VlIG9uIHA0
IHBtdS4KVGhpcyBwYXRjaCBzaG91bGQgZml4IGl0LgoKUmVwb3J0ZWQtYnk6IEdlb3JnZSBTcGVs
dmluIDxsaW51eEBob3Jpem9uLmNvbT4KUmVwb3J0ZWQtYnk6IE1lZWxpcyBSb29zIDxtcm9vc0Bs
aW51eC5lZT4KUmVwb3J0ZWQtYnk6IERvbiBaaWNrdXMgPGR6aWNrdXNAcmVkaGF0LmNvbT4KU2ln
bmVkLW9mZi1ieTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBvcGVudnoub3JnPgpDQzogSW5n
byBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+CkNDOiBMaW4gTWluZyA8bWluZy5tLmxpbkBpbnRlbC5j
b20+CkNDOiBEb24gWmlja3VzIDxkemlja3VzQHJlZGhhdC5jb20+CkNDOiBQZXRlciBaaWpsc3Ry
YSA8YS5wLnppamxzdHJhQGNoZWxsby5ubD4KLS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZXJm
X2V2ZW50X3A0LmggfCAgICAxICsKIGFyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudF9wNC5j
ICB8ICAgMTEgKysrKysrKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi50aXAvYXJjaC94ODYvaW5jbHVkZS9hc20v
cGVyZl9ldmVudF9wNC5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi50aXAub3JpZy9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9wZXJmX2V2ZW50X3A0LmgKKysrIGxpbnV4LTIuNi50aXAvYXJjaC94ODYv
aW5jbHVkZS9hc20vcGVyZl9ldmVudF9wNC5oCkBAIC0yMiw2ICsyMiw3IEBACiAKICNkZWZpbmUg
QVJDSF9QNF9DTlRSVkFMX0JJVFMJKDQwKQogI2RlZmluZSBBUkNIX1A0X0NOVFJWQUxfTUFTSwko
KDFVTEwgPDwgQVJDSF9QNF9DTlRSVkFMX0JJVFMpIC0gMSkKKyNkZWZpbmUgQVJDSF9QNF9VTkZM
QUdHRURfQklUCSgoMVVMTCkgPDwgKEFSQ0hfUDRfQ05UUlZBTF9CSVRTIC0gMSkpCiAKICNkZWZp
bmUgUDRfRVNDUl9FVkVOVF9NQVNLCTB4N2UwMDAwMDBVCiAjZGVmaW5lIFA0X0VTQ1JfRVZFTlRf
U0hJRlQJMjUKSW5kZXg6IGxpbnV4LTIuNi50aXAvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2
ZW50X3A0LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LnRpcC5vcmlnL2FyY2gveDg2L2tlcm5l
bC9jcHUvcGVyZl9ldmVudF9wNC5jCisrKyBsaW51eC0yLjYudGlwL2FyY2gveDg2L2tlcm5lbC9j
cHUvcGVyZl9ldmVudF9wNC5jCkBAIC03NzAsOSArNzcwLDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50
IHA0X3BtdV9jbGVhcl9jY2NyX292ZigKIAkJcmV0dXJuIDE7CiAJfQogCi0JLyogaXQgbWlnaHQg
YmUgdW5mbGFnZ2VkIG92ZXJmbG93ICovCi0JcmRtc3JsKGh3Yy0+ZXZlbnRfYmFzZSArIGh3Yy0+
aWR4LCB2KTsKLQlpZiAoISh2ICYgQVJDSF9QNF9DTlRSVkFMX01BU0spKQorCS8qCisJICogYXQg
c29tZSBjaXJjdW1zdGFuY2VzIHRoZSBvdmVyZmxvdyBtaWdodCBpc3N1ZSBOTUkgYnV0IGRpZAor
CSAqIG5vdCBzZXQgUDRfQ0NDUl9PVkYgYml0IHNvIHNpbmNlIGEgY291bnRlciBob2xkcyBhIG5l
Z2F0aXZlIHZhbHVlCisJICogd2Ugc2ltcGx5IGNoZWNrIGZvciBoaWdoIGJpdCBiZWluZyBzZXQs
IGlmIGl0J3MgY2xlYXJlZCBpdCBtZWFucworCSAqIHRoZSBjb3VudGVyIGhhcyByZWFjaGVkIHpl
cm8gdmFsdWUgYW5kIGNvbnRpbnVlZCBjb3VudGluZyBiZWZvcmUKKwkgKiByZWFsIE5NSSBzaWdu
YWwgd2FzIHJlY2VpdmVkCisJICovCisJaWYgKCEodiAmIEFSQ0hfUDRfVU5GTEFHR0VEX0JJVCkp
CiAJCXJldHVybiAxOwogCiAJcmV0dXJuIDA7Cg==
--20cf302078629baeff049b73dd04--
