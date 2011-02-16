Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1BPLII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:08:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37175 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab1BPLIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hWnA1qmW9FtzY/nCXZ9ELY2l0LqdAycRxQTfQEPqDUTcaaPCGFD/wA6LOyY22f1zG9
         JTjHLfN/YAKGWjMn+LRComtq/LqMO0+j0Ow11OpLwg4PbOqKZ9QLPX5k2lO9kY0iWbBG
         RPOD2sD0v+cnj2JLU7c/gxkBSQl85K0wL8JCY=
MIME-Version: 1.0
In-Reply-To: <20110216100957.GB20770@elte.hu>
References: <4D484853.9020409@gmail.com>
	<20110202023610.3799.qmail@science.horizon.com>
	<AANLkTi=X8vCuVOCMBJiCOB-8GZRF4-5RVx59QchecLz4@mail.gmail.com>
	<AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
	<AANLkTikx-7zJZaV2tgP=D=vZ12Brp9qrnyxLv_mVXQT3@mail.gmail.com>
	<20110216083747.GF16529@elte.hu>
	<AANLkTimXDquQV7c5yOM+1h-F08Lxti7Z5JJbbL7q7hNd@mail.gmail.com>
	<20110216085605.GA18842@elte.hu>
	<AANLkTi=JDw=BNg1ys5ifkPwY7XpapMz-1hn5bAXmYYfg@mail.gmail.com>
	<20110216100957.GB20770@elte.hu>
Date: Wed, 16 Feb 2011 14:08:02 +0300
Message-ID: <AANLkTinfuTfCck_FfaOHrDqQZZehtRzkBum4SpFoO=KJ@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Airlie <airlied@gmail.com>, George Spelvin <linux@horizon.com>,
        a.p.zijlstra@chello.nl, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Content-Type: multipart/mixed; boundary=0016363ba1846dab11049c644bbe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363ba1846dab11049c644bbe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 16, 2011 at 1:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
...
>>
>> For nonkgdb case 'unflagged nmi fix' patch should be enough. i've
>> tested it on non-ht machine by self. without it there is no lockup
>> but only a message about unknown nmi.
>
> Ok, please submit it ASAP then - that ought to address the regression. Pl=
ease Cc:
> Dave to the patch.
>
> Thanks,
>
> =A0 =A0 =A0 =A0Ingo
>

Ingo both patches are already in thread (attached to previous mail
since I've web
access at moment). So just to be sure the 'unflagged' nmi patch is
attached again,
this fix which should be aplied to -tip/master.

--0016363ba1846dab11049c644bbe
Content-Type: application/octet-stream; name=perf-x86-p4-unflagged-nmi
Content-Disposition: attachment; filename=perf-x86-p4-unflagged-nmi
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk8502vw1

RnJvbTogQ3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBvcGVudnoub3JnPgpTdWJqZWN0OiBbUEFU
Q0hdIHBlcmYsIHg4NjogUDQgUE1VIC0tIEZpeCB1bmZsYWdnZWQgb3ZlcmZsb3dzIHRlc3QKCkEg
Y291cGxlIG9mIHBlb3BsZSBoYXZlIHJlcG9ydGVkIGFuIHVua25vd24gTk1JIGlzc3VlIG9uIHA0
IHBtdS4KVGhpcyBwYXRjaCBzaG91bGQgZml4IGl0LgoKUmVwb3J0ZWQtYnk6IEdlb3JnZSBTcGVs
dmluIDxsaW51eEBob3Jpem9uLmNvbT4KUmVwb3J0ZWQtYnk6IE1lZWxpcyBSb29zIDxtcm9vc0Bs
aW51eC5lZT4KUmVwb3J0ZWQtYnk6IERvbiBaaWNrdXMgPGR6aWNrdXNAcmVkaGF0LmNvbT4KUmVw
b3J0ZWQtYnk6IERhdmUgQWlybGllIDxhaXJsaWVkQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTog
Q3lyaWxsIEdvcmN1bm92IDxnb3JjdW5vdkBvcGVudnoub3JnPgpDQzogSW5nbyBNb2xuYXIgPG1p
bmdvQGVsdGUuaHU+CkNDOiBMaW4gTWluZyA8bWluZy5tLmxpbkBpbnRlbC5jb20+CkNDOiBEb24g
Wmlja3VzIDxkemlja3VzQHJlZGhhdC5jb20+CkNDOiBQZXRlciBaaWpsc3RyYSA8YS5wLnppamxz
dHJhQGNoZWxsby5ubD4KLS0tCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZXJmX2V2ZW50X3A0Lmgg
fCAgICAxICsKIGFyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVudF9wNC5jICB8ICAgMTEgKysr
KysrKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygt
KQoKSW5kZXg6IGxpbnV4LTIuNi50aXAvYXJjaC94ODYvaW5jbHVkZS9hc20vcGVyZl9ldmVudF9w
NC5oCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi50aXAub3JpZy9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9wZXJmX2V2ZW50X3A0LmgKKysrIGxpbnV4LTIuNi50aXAvYXJjaC94ODYvaW5jbHVkZS9hc20v
cGVyZl9ldmVudF9wNC5oCkBAIC0yMiw2ICsyMiw3IEBACiAKICNkZWZpbmUgQVJDSF9QNF9DTlRS
VkFMX0JJVFMJKDQwKQogI2RlZmluZSBBUkNIX1A0X0NOVFJWQUxfTUFTSwkoKDFVTEwgPDwgQVJD
SF9QNF9DTlRSVkFMX0JJVFMpIC0gMSkKKyNkZWZpbmUgQVJDSF9QNF9VTkZMQUdHRURfQklUCSgo
MVVMTCkgPDwgKEFSQ0hfUDRfQ05UUlZBTF9CSVRTIC0gMSkpCiAKICNkZWZpbmUgUDRfRVNDUl9F
VkVOVF9NQVNLCTB4N2UwMDAwMDBVCiAjZGVmaW5lIFA0X0VTQ1JfRVZFTlRfU0hJRlQJMjUKSW5k
ZXg6IGxpbnV4LTIuNi50aXAvYXJjaC94ODYva2VybmVsL2NwdS9wZXJmX2V2ZW50X3A0LmMKPT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQotLS0gbGludXgtMi42LnRpcC5vcmlnL2FyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9l
dmVudF9wNC5jCisrKyBsaW51eC0yLjYudGlwL2FyY2gveDg2L2tlcm5lbC9jcHUvcGVyZl9ldmVu
dF9wNC5jCkBAIC03NzAsOSArNzcwLDE0IEBAIHN0YXRpYyBpbmxpbmUgaW50IHA0X3BtdV9jbGVh
cl9jY2NyX292ZigKIAkJcmV0dXJuIDE7CiAJfQogCi0JLyogaXQgbWlnaHQgYmUgdW5mbGFnZ2Vk
IG92ZXJmbG93ICovCi0JcmRtc3JsKGh3Yy0+ZXZlbnRfYmFzZSArIGh3Yy0+aWR4LCB2KTsKLQlp
ZiAoISh2ICYgQVJDSF9QNF9DTlRSVkFMX01BU0spKQorCS8qCisJICogYXQgc29tZSBjaXJjdW1z
dGFuY2VzIHRoZSBvdmVyZmxvdyBtaWdodCBpc3N1ZSBOTUkgYnV0IGRpZAorCSAqIG5vdCBzZXQg
UDRfQ0NDUl9PVkYgYml0IHNvIHNpbmNlIGEgY291bnRlciBob2xkcyBhIG5lZ2F0aXZlIHZhbHVl
CisJICogd2Ugc2ltcGx5IGNoZWNrIGZvciBoaWdoIGJpdCBiZWluZyBzZXQsIGlmIGl0J3MgY2xl
YXJlZCBpdCBtZWFucworCSAqIHRoZSBjb3VudGVyIGhhcyByZWFjaGVkIHplcm8gdmFsdWUgYW5k
IGNvbnRpbnVlZCBjb3VudGluZyBiZWZvcmUKKwkgKiByZWFsIE5NSSBzaWduYWwgd2FzIHJlY2Vp
dmVkCisJICovCisJaWYgKCEodiAmIEFSQ0hfUDRfVU5GTEFHR0VEX0JJVCkpCiAJCXJldHVybiAx
OwogCiAJcmV0dXJuIDA7Cg==
--0016363ba1846dab11049c644bbe--
