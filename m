Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab1ANBZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 20:25:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab1ANBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 20:25:13 -0500
MIME-Version: 1.0
In-Reply-To: <20110114104310.d975c69c.sfr@canb.auug.org.au>
References: <20110114104310.d975c69c.sfr@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Jan 2011 17:24:17 -0800
Message-ID: <AANLkTi=auk_ejRxzSj-bbFJz4gTCfK79qRe8JeFH2T8z@mail.gmail.com>
Subject: Re: linux-next: build failure in Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00221532c77826ea0d0499c44cf5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00221532c77826ea0d0499c44cf5
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jan 13, 2011 at 3:43 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> While building Linus' tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Ok, I applied the attached, which makes it all build. I don't actually
have a ecryptfs filesystem to test with, though.

Bad Al. Bad, bad Al.

                        Linus

--00221532c77826ea0d0499c44cf5
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_giwenkvy1

Y29tbWl0IDYyNTRiMzJiNTc5MWU0N2JhMWM2NzlkMDIzZjI2OTg1ZmEzNDc1NWEKQXV0aG9yOiBM
aW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+CkRhdGU6ICAgVGh1
IEphbiAxMyAxNzoxOTozOCAyMDExIC0wODAwCgogICAgZWNyeXB0ZnM6IGZpeCBicm9rZW4gYnVp
bGQKICAgIAogICAgU3RlcGhlbiBSb3Rod2VsbCByZXBvcnRzIHRoYXQgdGhlIHZmcyBtZXJnZSBi
cm9rZSB0aGUgYnVpbGQgb2YgZWNyeXB0ZnMuCiAgICBUaGUgYnJlYWthZ2UgY29tZXMgZnJvbSBj
b21taXQgNjZjYjc2NjY2ZDY5ICgic2FuaXRpemUgZWNyeXB0ZnMKICAgIC0+bW91bnQoKSIpIHdo
aWNoIHdhcyBvYnZpb3VzbHkgbm90IGV2ZW4gYnVpbGQgdGVzdGVkLiBUc3NrLCB0c3NrLCBBbC4K
ICAgIAogICAgVGhpcyBpcyB0aGUgbWluaW1hbCBidWlsZCBmaXh1cCBmb3IgdGhlIHNpdHVhdGlv
biwgYWx0aG91Z2ggSSBkb24ndCBoYXZlCiAgICBhIGZpbGVzeXN0ZW0gdG8gYWN0dWFsbHkgdGVz
dCBpdCB3aXRoLgogICAgCiAgICBSZXBvcnRlZC1ieTogU3RlcGhlbiBSb3Rod2VsbCA8c2ZyQGNh
bmIuYXV1Zy5vcmcuYXU+CiAgICBDYzogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+
CiAgICBTaWduZWQtb2ZmLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+Ci0tLQogZnMvZWNyeXB0ZnMvbWFpbi5jIHwgICAgNSArKy0tLQogMSBmaWxlcyBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
ZWNyeXB0ZnMvbWFpbi5jIGIvZnMvZWNyeXB0ZnMvbWFpbi5jCmluZGV4IDllZDQ3NjkuLmQzYjI4
YWIgMTAwNjQ0Ci0tLSBhL2ZzL2VjcnlwdGZzL21haW4uYworKysgYi9mcy9lY3J5cHRmcy9tYWlu
LmMKQEAgLTE0MSwxMyArMTQxLDEyIEBAIGludCBlY3J5cHRmc19pbml0X3BlcnNpc3RlbnRfZmls
ZShzdHJ1Y3QgZGVudHJ5ICplY3J5cHRmc19kZW50cnkpCiAJcmV0dXJuIHJjOwogfQogCi1zdGF0
aWMgaW5vZGUgKmVjcnlwdGZzX2dldF9pbm9kZShzdHJ1Y3QgaW5vZGUgKmxvd2VyX2lub2RlLAor
c3RhdGljIHN0cnVjdCBpbm9kZSAqZWNyeXB0ZnNfZ2V0X2lub2RlKHN0cnVjdCBpbm9kZSAqbG93
ZXJfaW5vZGUsCiAJCSAgICAgICBzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiKQogewogCXN0cnVjdCBp
bm9kZSAqaW5vZGU7CiAJaW50IHJjID0gMDsKIAotCWxvd2VyX2lub2RlID0gbG93ZXJfZGVudHJ5
LT5kX2lub2RlOwogCWlmIChsb3dlcl9pbm9kZS0+aV9zYiAhPSBlY3J5cHRmc19zdXBlcmJsb2Nr
X3RvX2xvd2VyKHNiKSkgewogCQlyYyA9IC1FWERFVjsKIAkJZ290byBvdXQ7CkBAIC0yMDIsNyAr
MjAxLDcgQEAgaW50IGVjcnlwdGZzX2ludGVycG9zZShzdHJ1Y3QgZGVudHJ5ICpsb3dlcl9kZW50
cnksIHN0cnVjdCBkZW50cnkgKmRlbnRyeSwKIHsKIAlzdHJ1Y3QgaW5vZGUgKmxvd2VyX2lub2Rl
ID0gbG93ZXJfZGVudHJ5LT5kX2lub2RlOwogCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBlY3J5cHRm
c19nZXRfaW5vZGUobG93ZXJfaW5vZGUsIHNiKTsKLQlpZiAoSVNfRVJSKGlub2RlKQorCWlmIChJ
U19FUlIoaW5vZGUpKQogCQlyZXR1cm4gUFRSX0VSUihpbm9kZSk7CiAJaWYgKGZsYWdzICYgRUNS
WVBURlNfSU5URVJQT1NFX0ZMQUdfRF9BREQpCiAJCWRfYWRkKGRlbnRyeSwgaW5vZGUpOwo=
--00221532c77826ea0d0499c44cf5--
