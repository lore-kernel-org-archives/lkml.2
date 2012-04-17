Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab2DQBei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:34:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64839 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2DQBeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAE_yGnAJ5pEZDXDp1uFaUqZa758+HZbcbcLCgEQh4YYnFBDHxw@mail.gmail.com>
References: <CAE_yGnAWsWQHCSCLA-LCuugOGTf5L4v2NcQatar4Vv421TNQcw@mail.gmail.com>
	<CAE_yGnDYkoJYVus-iPinSnqTj1CDfaf-oScPjZ2ibDaeeWF0oQ@mail.gmail.com>
	<CAE9FiQW5LwRdM2NRUQZjBkyg023gwXa6r10Ym2bo0L1vk74yBg@mail.gmail.com>
	<CAE_yGnAJ5pEZDXDp1uFaUqZa758+HZbcbcLCgEQh4YYnFBDHxw@mail.gmail.com>
Date: Mon, 16 Apr 2012 18:34:36 -0700
X-Google-Sender-Auth: dAcq_Uwtu4Qwq7ta09QMen0Ps6g
Message-ID: <CAE9FiQU2JkJPhw4QA0B8+XQDM93LUJ-tcYDcJaXBvHsrt9KRpQ@mail.gmail.com>
Subject: Re: can't boot my laptop with kernel-3.3.*
From: Yinghai Lu <yinghai@kernel.org>
To: Scant Light <scantlight@gmail.com>
Cc: "the arch/x86 maintainers" <x86@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8ff1cc40112ad404bdd5f141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1cc40112ad404bdd5f141
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Apr 16, 2012 at 5:41 PM, Scant Light <scantlight@gmail.com> wrote:
> 9. http://www.pasteall.org/pic/30333

mpc size if 0, please apply attached patch.

Thanks

Yinghai

--e89a8ff1cc40112ad404bdd5f141
Content-Type: application/octet-stream; name="mpc_size.patch"
Content-Disposition: attachment; filename="mpc_size.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h14a4gxz0

U3ViamVjdDogW1BBVENIXSB4ODY6IENoZWNrIG1wYyBzaXplIGJlZm9yZSByZXNlcnZlIGl0CgpT
aWduLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hhaUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4
Ni9rZXJuZWwvbXBwYXJzZS5jIHwgICAgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRp
b25zKCspCgpJbmRleDogbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9tcHBhcnNlLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJjaC94ODYva2VybmVsL21wcGFyc2UuYworKysgbGlu
dXgtMi42L2FyY2gveDg2L2tlcm5lbC9tcHBhcnNlLmMKQEAgLTQ0OCw2ICs0NDgsMTAgQEAgc3Rh
dGljIHVuc2lnbmVkIGxvbmcgX19pbml0IGdldF9tcGNfc2l6ZQogCW1wYyA9IGVhcmx5X2lvcmVt
YXAocGh5c3B0ciwgUEFHRV9TSVpFKTsKIAlzaXplID0gbXBjLT5sZW5ndGg7CiAJZWFybHlfaW91
bm1hcChtcGMsIFBBR0VfU0laRSk7CisJaWYgKCFzaXplKSB7CisJCXNpemUgPSBzaXplb2YoKm1w
Yyk7CisJCXByaW50ayhLRVJOX1dBUk5JTkcsICIgIG1wYyBzaXplIGFkanVzdCBmcm9tIDAgdG8g
JWx4XG4iLCBzaXplKTsKKwl9CiAJYXBpY19wcmludGsoQVBJQ19WRVJCT1NFLCAiICBtcGM6ICVs
eC0lbHhcbiIsIHBoeXNwdHIsIHBoeXNwdHIgKyBzaXplKTsKIAogCXJldHVybiBzaXplOwo=
--e89a8ff1cc40112ad404bdd5f141--
