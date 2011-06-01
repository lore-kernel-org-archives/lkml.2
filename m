Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab1FAIsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:48:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58287 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab1FAIsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:48:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qm5jrItn3FxG5mNYriDiCoIyTseUmCkX29v12+eyV0w8YOcwkni6gsknPf9PVZOXDf
         kG99Ot1Us9QoyJ2bDAIQtnlJ69vSN+oHXvZ7+CWWkW0DrqmNBRBm28nfSmhwHl6uA8Iv
         vYnb8vT4E4V3vyJDcU8DNiAOfN7BPA4ZgGQ8g=
MIME-Version: 1.0
In-Reply-To: <20110527045156.GA2442@p183.telecom.by>
References: <201103072305.p27N5hKT000474@imap1.linux-foundation.org>
	<20110307232655.GA7234@p183.telecom.by>
	<AANLkTi=-PcbpBjWZuno1fjwZD-tGmC+JMxrzMr1FNwu7@mail.gmail.com>
	<AANLkTikxbAfpHCWzvLscdHccOju=Q1tN0pvcu_=jbeQ_@mail.gmail.com>
	<20110308082409.GA4913@p183.telecom.by>
	<AANLkTik2qpLnxUfD9NyPFSbO5PyYFeRv8cM=Nz1t=UOZ@mail.gmail.com>
	<20110308090247.GA20281@p183.telecom.by>
	<AANLkTi=Y32JLeuwagvAsuRg61VHEPQqpReot8ndcajrP@mail.gmail.com>
	<20110526125918.ba161d6f.akpm@linux-foundation.org>
	<20110527045156.GA2442@p183.telecom.by>
Date: Wed, 1 Jun 2011 16:48:04 +0800
Message-ID: <BANLkTin1ewjj_XmSTYp+X4ia-4hyHQfVcQ@mail.gmail.com>
Subject: Re: + sysctl-add-proc_dointvec_unsigned-handler.patch added to -mm tree
From: Dave Young <hidave.darkstar@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd68c982ef6b704a4a294b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd68c982ef6b704a4a294b5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, May 27, 2011 at 12:51 PM, Alexey Dobriyan <adobriyan@gmail.com> wro=
te:
> On Thu, May 26, 2011 at 12:59:18PM -0700, Andrew Morton wrote:
>>
>> So... where did we end up with this discussion?
>>
>> There are four patches involved:
>
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-add-proc_dointve=
c_unsigned-handler.patch
>> http://userweb.kernel.org/~akpm/mmotm/broken-out/sysctl-use-proc_dointve=
c_unsigned-where-appropriate.patch
>
> This still sucks:
> * .extra2 aka max is ignored(!)
> * even if not ignored, API can't be used on array, because min and max
> =C2=A0boundaries should match wrt length.
>

Andrew, I'm offline last days, sorry for late reply.

Alexey, I updated the patch, do you feel better?

--=20
Regards
dave

--000e0cd68c982ef6b704a4a294b5
Content-Type: text/x-pascal; charset=US-ASCII; 
	name="sysctl-add-proc_dointvec_unsigned-handler-v2.patch"
Content-Disposition: attachment; 
	filename="sysctl-add-proc_dointvec_unsigned-handler-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_goe1prz70

RnJvbTogRGF2ZSBZb3VuZyA8aGlkYXZlLmRhcmtzdGFyQGdtYWlsLmNvbT4KCkFkZCBhIHByb2Nf
ZG9pbnR2ZWNfdW5zaWduZWQoKSBzeXNjdGwgaGFuZGxlciBmb3IgcG9zaXRpdmUgdmFsdWUgY2Fz
ZXMuCgpWMiBjaGFuZ2VzOgpBcyB0byBBbGV4ZXkgRG9icml5YW46IGRvIG5vdCBpZ25vcmUgbWF4
IGluIHByb2NfZG9pbnR2ZWNfdW5zaWduZWQgcGFyYW0gc2V0dXAuCgpTaWduZWQtb2ZmLWJ5OiBE
YXZlIFlvdW5nIDxoaWRhdmUuZGFya3N0YXJAZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbmRy
ZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgotLS0KCiBpbmNsdWRlL2xpbnV4
L3N5c2N0bC5oIHwgICAgMiArKwoga2VybmVsL3N5c2N0bC5jICAgICAgICB8ICAgMjcgKysrKysr
KysrKysrKysrKysrKysrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKykK
Ci0tLSBsaW51eC0yLjYub3JpZy9pbmNsdWRlL2xpbnV4L3N5c2N0bC5oCTIwMTEtMDQtMjcgMTM6
NTg6NTEuMzQzMzMyNTExICswODAwCisrKyBsaW51eC0yLjYvaW5jbHVkZS9saW51eC9zeXNjdGwu
aAkyMDExLTA2LTAxIDE2OjI4OjA3LjY3OTUzNjg5MiArMDgwMApAQCAtOTcxLDYgKzk3MSw4IEBA
IGV4dGVybiBpbnQgcHJvY19kb2ludHZlYyhzdHJ1Y3QgY3RsX3RhYmwKIAkJCSB2b2lkIF9fdXNl
ciAqLCBzaXplX3QgKiwgbG9mZl90ICopOwogZXh0ZXJuIGludCBwcm9jX2RvaW50dmVjX21pbm1h
eChzdHJ1Y3QgY3RsX3RhYmxlICosIGludCwKIAkJCQl2b2lkIF9fdXNlciAqLCBzaXplX3QgKiwg
bG9mZl90ICopOworZXh0ZXJuIGludCBwcm9jX2RvaW50dmVjX3Vuc2lnbmVkKHN0cnVjdCBjdGxf
dGFibGUgKiwgaW50LAorCQkJCXZvaWQgX191c2VyICosIHNpemVfdCAqLCBsb2ZmX3QgKik7CiBl
eHRlcm4gaW50IHByb2NfZG9pbnR2ZWNfamlmZmllcyhzdHJ1Y3QgY3RsX3RhYmxlICosIGludCwK
IAkJCQkgdm9pZCBfX3VzZXIgKiwgc2l6ZV90ICosIGxvZmZfdCAqKTsKIGV4dGVybiBpbnQgcHJv
Y19kb2ludHZlY191c2VyaHpfamlmZmllcyhzdHJ1Y3QgY3RsX3RhYmxlICosIGludCwKLS0tIGxp
bnV4LTIuNi5vcmlnL2tlcm5lbC9zeXNjdGwuYwkyMDExLTA2LTAxIDE2OjA4OjUxLjY4Mjg3Mjg4
MyArMDgwMAorKysgbGludXgtMi42L2tlcm5lbC9zeXNjdGwuYwkyMDExLTA2LTAxIDE2OjI5OjQ4
LjM4OTUzNjY2MiArMDgwMApAQCAtMjQ3Niw2ICsyNDc2LDMzIEBAIGludCBwcm9jX2RvaW50dmVj
X21pbm1heChzdHJ1Y3QgY3RsX3RhYmwKIAkJCQlkb19wcm9jX2RvaW50dmVjX21pbm1heF9jb252
LCAmcGFyYW0pOwogfQogCisvKioKKyAqIHByb2NfZG9pbnR2ZWNfdW5zaWduZWQgLSByZWFkIGEg
dmVjdG9yIG9mIGludGVnZXJzIHdpdGggcG9zaXRpdmUgdmFsdWVzCisgKiBAdGFibGU6IHRoZSBz
eXNjdGwgdGFibGUKKyAqIEB3cml0ZTogJVRSVUUgaWYgdGhpcyBpcyBhIHdyaXRlIHRvIHRoZSBz
eXNjdGwgZmlsZQorICogQGJ1ZmZlcjogdGhlIHVzZXIgYnVmZmVyCisgKiBAbGVucDogdGhlIHNp
emUgb2YgdGhlIHVzZXIgYnVmZmVyCisgKiBAcHBvczogZmlsZSBwb3NpdGlvbgorICoKKyAqIFJl
YWRzL3dyaXRlcyB1cCB0byB0YWJsZS0+bWF4bGVuL3NpemVvZih1bnNpZ25lZCBpbnQpIGludGVn
ZXIKKyAqIHZhbHVlcyBmcm9tL3RvIHRoZSB1c2VyIGJ1ZmZlciwgdHJlYXRlZCBhcyBhbiBBU0NJ
SSBzdHJpbmcuCisgKgorICogVGhpcyByb3V0aW5lIHdpbGwgZW5zdXJlIHRoZSB2YWx1ZXMgYXJl
IHBvc2l0aXZlLgorICoKKyAqIFJldHVybnMgMCBvbiBzdWNjZXNzLgorICovCitpbnQgcHJvY19k
b2ludHZlY191bnNpZ25lZChzdHJ1Y3QgY3RsX3RhYmxlICp0YWJsZSwgaW50IHdyaXRlLAorCQkg
IHZvaWQgX191c2VyICpidWZmZXIsIHNpemVfdCAqbGVucCwgbG9mZl90ICpwcG9zKQoreworCXN0
cnVjdCBkb19wcm9jX2RvaW50dmVjX21pbm1heF9jb252X3BhcmFtIHBhcmFtID0geworCQkubWlu
ID0gJnplcm8sCisJCS5tYXggPSAoaW50ICopIHRhYmxlLT5leHRyYTIsCisJfTsKKwlyZXR1cm4g
ZG9fcHJvY19kb2ludHZlYyh0YWJsZSwgd3JpdGUsIGJ1ZmZlciwgbGVucCwgcHBvcywKKwkJCQlk
b19wcm9jX2RvaW50dmVjX21pbm1heF9jb252LCAmcGFyYW0pOworfQorRVhQT1JUX1NZTUJPTChw
cm9jX2RvaW50dmVjX3Vuc2lnbmVkKTsKKwogc3RhdGljIGludCBfX2RvX3Byb2NfZG91bG9uZ3Zl
Y19taW5tYXgodm9pZCAqZGF0YSwgc3RydWN0IGN0bF90YWJsZSAqdGFibGUsIGludCB3cml0ZSwK
IAkJCQkgICAgIHZvaWQgX191c2VyICpidWZmZXIsCiAJCQkJICAgICBzaXplX3QgKmxlbnAsIGxv
ZmZfdCAqcHBvcywK
--000e0cd68c982ef6b704a4a294b5--
