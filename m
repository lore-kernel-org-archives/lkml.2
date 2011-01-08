Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab1AHSl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 13:41:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63408 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1AHSl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 13:41:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=VDbvr1Fx68ftTAyqMhSE/mpUU6JXwuK4BfdHhJoXYTdJV8C0q90QwyV6Qp6kBolRJb
         C+2HQq0x2RR4fInq8Rp7otnx+4AH5vx6p3EJnlHN7HE9F6sqtH8kAsZhLmpG86gQiegA
         8T/nosxNCAJ48CN+BGukldCG4KSTPDHzRPpu8=
Message-ID: <4D28AFD1.3020808@gmail.com>
Date: Sat, 08 Jan 2011 19:41:21 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.13) Gecko/20100916 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Iain Paton <selsinork@gmail.com>
CC: Michael Chan <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.37 vlans on bnx2 not functional, panic with tcpdump
References: <4D2634DE.2060907@gmail.com> <1294357941.21580.2.camel@HP1> <1294361206.21580.7.camel@HP1> <AANLkTi=PGPVRbS3XViskpZ0GSS8ouBcgVZYYG9EoM-Nz@mail.gmail.com> <1294422653.14051.11.camel@HP1> <4D2754F9.8050707@gmail.com>
In-Reply-To: <4D2754F9.8050707@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090806050204080902040303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090806050204080902040303
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Iain Paton wrote:
...
> So you can consider any bnx2 cause for this closed. I'll get back to the
> list if I can come up with any more useful info.

Hi Iain,
If it's not a problem, please try if the attached debugging patch
(not tested) can change anything.

Thanks,
Jarek P.

--------------090806050204080902040303
Content-Type: text/plain;
 name="dev.c.deliver_skb.1.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dev.c.deliver_skb.1.diff"

ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2NvcmUvZGV2LmMKaW5kZXggMGRk
NTRhNi4uOTI0NDM3MyAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvZGV2LmMKKysrIGIvbmV0L2Nv
cmUvZGV2LmMKQEAgLTI3MjAsNiArMjcyMCwxNyBAQCBzdGF0aWMgaW5saW5lIGludCBkZWxp
dmVyX3NrYihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCXJldHVybiBwdF9wcmV2LT5mdW5jKHNr
Yiwgc2tiLT5kZXYsIHB0X3ByZXYsIG9yaWdfZGV2KTsKIH0KIAorc3RhdGljIGlubGluZSBp
bnQgZGVsaXZlcl9za2JfY2xvbmUoc3RydWN0IHNrX2J1ZmYgKnNrYiwKKwkJCSAgICAgIHN0
cnVjdCBwYWNrZXRfdHlwZSAqcHRfcHJldiwKKwkJCSAgICAgIHN0cnVjdCBuZXRfZGV2aWNl
ICpvcmlnX2RldikKK3sKKwlzdHJ1Y3Qgc2tfYnVmZiAqbnNrYiA9IHNrYl9jbG9uZShza2Is
IEdGUF9BVE9NSUMpOworCisJaWYgKCFuc2tiKQorCQlyZXR1cm4gMDsKKwlyZXR1cm4gcHRf
cHJldi0+ZnVuYyhuc2tiLCBuc2tiLT5kZXYsIHB0X3ByZXYsIG9yaWdfZGV2KTsKK30KKwog
I2lmIChkZWZpbmVkKENPTkZJR19CUklER0UpIHx8IGRlZmluZWQoQ09ORklHX0JSSURHRV9N
T0RVTEUpKSAmJiBcCiAgICAgKGRlZmluZWQoQ09ORklHX0FUTV9MQU5FKSB8fCBkZWZpbmVk
KENPTkZJR19BVE1fTEFORV9NT0RVTEUpKQogLyogVGhpcyBob29rIGlzIGRlZmluZWQgaGVy
ZSBmb3IgQVRNIExBTkUgKi8KQEAgLTI5NTAsNyArMjk2MSw3IEBAIHN0YXRpYyBpbnQgX19u
ZXRpZl9yZWNlaXZlX3NrYihzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCQlpZiAocHR5cGUtPmRl
diA9PSBudWxsX29yX29yaWcgfHwgcHR5cGUtPmRldiA9PSBza2ItPmRldiB8fAogCQkgICAg
cHR5cGUtPmRldiA9PSBvcmlnX2RldikgewogCQkJaWYgKHB0X3ByZXYpCi0JCQkJcmV0ID0g
ZGVsaXZlcl9za2Ioc2tiLCBwdF9wcmV2LCBvcmlnX2Rldik7CisJCQkJcmV0ID0gZGVsaXZl
cl9za2JfY2xvbmUoc2tiLCBwdF9wcmV2LCBvcmlnX2Rldik7CiAJCQlwdF9wcmV2ID0gcHR5
cGU7CiAJCX0KIAl9CkBAIC0yOTc2LDcgKzI5ODcsNyBAQCBuY2xzOgogCiAJaWYgKHZsYW5f
dHhfdGFnX3ByZXNlbnQoc2tiKSkgewogCQlpZiAocHRfcHJldikgewotCQkJcmV0ID0gZGVs
aXZlcl9za2Ioc2tiLCBwdF9wcmV2LCBvcmlnX2Rldik7CisJCQlyZXQgPSBkZWxpdmVyX3Nr
Yl9jbG9uZShza2IsIHB0X3ByZXYsIG9yaWdfZGV2KTsKIAkJCXB0X3ByZXYgPSBOVUxMOwog
CQl9CiAJCWlmICh2bGFuX2h3YWNjZWxfZG9fcmVjZWl2ZSgmc2tiKSkgewo=
--------------090806050204080902040303--
