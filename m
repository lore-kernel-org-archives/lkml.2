Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0GAJGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:06:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34742 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0GAJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YdBtwLF9SnYnd53xCHSdqP8AL2qsNdVxhp906ryJ4pQ3PhhjoXkpuZ9vA6DMqI3u9m
         8jeVFoscsDwrRPCpb7YsJJhl+F+kiyWKSxy6qwn2AC0QmK4S36JgpjADeQ9GdKpZ6CFr
         4MTMzv0RyYc9iPZ5YFN/KN78DGOcZ5RtVTX/4=
MIME-Version: 1.0
In-Reply-To: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
References: <AANLkTikNcAvyHf1yHPweNBVSCSPNmq-JaEOgYW2FYUGJ@mail.gmail.com>
Date: Thu, 1 Jul 2010 02:06:35 -0700
Message-ID: <AANLkTimvYT9MFPzX7xmCXPZ6ScFQZxO3zSKlcqczd_GO@mail.gmail.com>
Subject: Re: [git pull] (updated) OF-related build breakage fixes
From: Dan Williams <dan.j.williams@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
       Anatolij Gustschin <agust@denx.de>
Content-Type: multipart/mixed; boundary=0050450141328df8d3048a4fc979
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0050450141328df8d3048a4fc979
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 2, 2010 at 8:06 PM, Grant Likely <grant.likely@secretlab.ca> wr=
ote:
> Updated pull request. =A0Added more fixes from Anatolij of the same sort.

Here is one more (attached) that seems to have escaped.

--
Dan

--0050450141328df8d3048a4fc979
Content-Type: application/octet-stream; name="fix-ppc4xx-adma-build.patch"
Content-Disposition: attachment; filename="fix-ppc4xx-adma-build.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gb3de2rp0

b2YvZG1hOiBmaXggcmVtYWluaW5nIHBwYzR4eCBidWlsZCBicmVha2FnZQoKRnJvbTogRGFuIFdp
bGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+CgpDb21taXQgMDVjMDI1NDIgIm9mL2Rt
YTogZml4IGJ1aWxkIGJyZWFrYWdlIGluIHBwYzR4eCBhZG1hIGRyaXZlciIKbWlzc2VkIG9uZSBj
b252ZXJzaW9uIHNpdGUuCgpDYzogQW5hdG9saWogR3VzdHNjaGluIDxhZ3VzdEBkZW54LmRlPgpD
YzogR3JhbnQgTGlrZWx5IDxncmFudC5saWtlbHlAc2VjcmV0bGFiLmNhPgpTaWduZWQtb2ZmLWJ5
OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KLS0tCgogZHJpdmVycy9k
bWEvcHBjNHh4L2FkbWEuYyB8ICAgIDQgKysrLQogMSBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb25zKC0pCgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL3BwYzR4eC9h
ZG1hLmMgYi9kcml2ZXJzL2RtYS9wcGM0eHgvYWRtYS5jCmluZGV4IDVhMjJjYTYuLjdjMzc0Nzkg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZG1hL3BwYzR4eC9hZG1hLmMKKysrIGIvZHJpdmVycy9kbWEv
cHBjNHh4L2FkbWEuYwpAQCAtNDI1NywxMCArNDI1NywxMiBAQCBzdGF0aWMgaW50IHBwYzQ0MHNw
ZV9hZG1hX3NldHVwX2lycXMoc3RydWN0IHBwYzQ0MHNwZV9hZG1hX2RldmljZSAqYWRldiwKIAkJ
CQkgICAgIHN0cnVjdCBwcGM0NDBzcGVfYWRtYV9jaGFuICpjaGFuLAogCQkJCSAgICAgaW50ICpp
bml0Y29kZSkKIHsKKwlzdHJ1Y3Qgb2ZfZGV2aWNlICpvZmRldjsKIAlzdHJ1Y3QgZGV2aWNlX25v
ZGUgKm5wOwogCWludCByZXQ7CiAKLQlucCA9IGNvbnRhaW5lcl9vZihhZGV2LT5kZXYsIHN0cnVj
dCBvZl9kZXZpY2UsIGRldiktPm5vZGU7CisJb2ZkZXYgPSBjb250YWluZXJfb2YoYWRldi0+ZGV2
LCBzdHJ1Y3Qgb2ZfZGV2aWNlLCBkZXYpOworCW5wID0gb2ZkZXYtPmRldi5vZl9ub2RlOwogCWlm
IChhZGV2LT5pZCAhPSBQUEM0NDBTUEVfWE9SX0lEKSB7CiAJCWFkZXYtPmVycl9pcnEgPSBpcnFf
b2ZfcGFyc2VfYW5kX21hcChucCwgMSk7CiAJCWlmIChhZGV2LT5lcnJfaXJxID09IE5PX0lSUSkg
ewo=
--0050450141328df8d3048a4fc979--
