Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0FLCne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:43:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35747 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0FLCnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q0X7OT8UXsz/ubUpc0Cr0kkI1lp7txUrAQ0HwzE8Xx+bAkx5ZmSQCuryE9uaNbRFeJ
         wU5velvQNK0QvKa0TglX2/e/V0x0H5CDU1dwf5Gyn7AP/h5ACDUx8JaWetURxwOS2swH
         7c1DQ+3TewvSJTOEsNX/NhLtNOfpdgBkhpyJA=
MIME-Version: 1.0
In-Reply-To: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
Date: Sat, 12 Jun 2010 10:43:31 +0800
Message-ID: <AANLkTin1cUkn_Cw5P0AR8NTx5prNF34bajZD0bPoavP2@mail.gmail.com>
Subject: Re: mmotm 2010-06-11-16-40 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174ff314a1375f0488cc38d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174ff314a1375f0488cc38d5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 12, 2010 at 7:40 AM,  <akpm@linux-foundation.org> wrote:
> The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
>
> =C2=A0 http://userweb.kernel.org/~akpm/mmotm/
>
> and will soon be available at
>
> =C2=A0 git://zen-kernel.org/kernel/mmotm.git
>

Hi, andrew

building failed with:
  AS      arch/x86/kernel/entry_32.o
/home/dave/src/linux-2.6.35/arch/x86/include/asm/olpc_ofw.h: Assembler mess=
ages:
/home/dave/src/linux-2.6.35/arch/x86/include/asm/olpc_ofw.h:29: Error:
no such instruction: `static inline void
olpc_ofw_detect_range(void){}'
make[2]: *** [arch/x86/kernel/entry_32.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

Attached a patch to fix it (I have not appropriate email client now,
sorry for the inconvenience )

--0015174ff314a1375f0488cc38d5
Content-Type: application/octet-stream; name="hidave_build_fix.patch"
Content-Disposition: attachment; filename="hidave_build_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gabuaisu0

YWRkICJpZm5kZWYgX19BU1NFTUJMRVJfXyIgdG8gZml4IGJ1aWxkIHdhcm5pbmdzCkZpeCBidWls
ZCBmYWlsaW5nIG9mIG9scGNfb2Z3LmgKCkFkZCBpZm5kZWYgX19BU1NFTUJMRVJfXyBhcm91bmQg
dGhlIGZ1bmN0aW9uIGRlY2xhcmF0aW9uCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIFlvdW5nIDxoaWRh
dmUuZGFya3N0YXJAZ21haWwuY29tPgotLS0KIGFyY2gveDg2L2luY2x1ZGUvYXNtL29scGNfb2Z3
LmggfCAgICAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgotLS0gbGludXgt
Mi42LjM1Lm9yaWcvYXJjaC94ODYvaW5jbHVkZS9hc20vb2xwY19vZncuaAkyMDEwLTA2LTEyIDA5
OjU3OjUyLjAwMDAwMDAwMCArMDgwMAorKysgbGludXgtMi42LjM1L2FyY2gveDg2L2luY2x1ZGUv
YXNtL29scGNfb2Z3LmgJMjAxMC0wNi0xMiAxMDoxNTo1OC40ODAwMDAzNDkgKzA4MDAKQEAgLTI2
LDcgKzI2LDkgQEAgdm9pZCBvbHBjX29md19kZXRlY3RfcmFuZ2Uodm9pZCk7CiAKICNlbHNlCiAK
KyNpZm5kZWYgX19BU1NFTUJMRVJfXwogc3RhdGljIGlubGluZSB2b2lkIG9scGNfb2Z3X2RldGVj
dF9yYW5nZSh2b2lkKSB7IH0KKyNlbmRpZgogCiAjZW5kaWYKIAo=
--0015174ff314a1375f0488cc38d5--
