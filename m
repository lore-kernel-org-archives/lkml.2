Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0LQBvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:51:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41270 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0LQBvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:51:45 -0500
Message-ID: <4D0AC213.3050102@zytor.com>
Date: Thu, 16 Dec 2010 17:51:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216143925.GA13870@redhat.com> <4D0A3E31.4000109@zytor.com> <4D0A4C51.3070008@kernel.org> <4D0A6F66.1010006@zytor.com> <4D0AA116.4050707@kernel.org> <4D0AA592.3060805@kernel.org> <4D0AB14F.9050900@kernel.org>
In-Reply-To: <4D0AB14F.9050900@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------000508030907020100050601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000508030907020100050601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Can whomever has a test case for this please test the attached test patch?

	-hpa


--------------000508030907020100050601
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9taXNjLmMgYi9hcmNoL3g4
Ni9ib290L2NvbXByZXNzZWQvbWlzYy5jCmluZGV4IDIzZjMxNWMuLjMyNWMwNTIgMTAwNjQ0
Ci0tLSBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9taXNjLmMKKysrIGIvYXJjaC94ODYv
Ym9vdC9jb21wcmVzc2VkL21pc2MuYwpAQCAtMzU1LDcgKzM1NSw3IEBAIGFzbWxpbmthZ2Ug
dm9pZCBkZWNvbXByZXNzX2tlcm5lbCh2b2lkICpybW9kZSwgbWVtcHRyIGhlYXAsCiAJaWYg
KGhlYXAgPiAweDNmZmZmZmZmZmZmZlVMKQogCQllcnJvcigiRGVzdGluYXRpb24gYWRkcmVz
cyB0b28gbGFyZ2UiKTsKICNlbHNlCi0JaWYgKGhlYXAgPiAoKC1fX1BBR0VfT0ZGU0VULSg1
MTI8PDIwKS0xKSAmIDB4N2ZmZmZmZmYpKQorCWlmIChoZWFwID4gKCgtX19QQUdFX09GRlNF
VC0oMTI4PDwyMCktMSkgJiAweDdmZmZmZmZmKSkKIAkJZXJyb3IoIkRlc3RpbmF0aW9uIGFk
ZHJlc3MgdG9vIGxhcmdlIik7CiAjZW5kaWYKICNpZm5kZWYgQ09ORklHX1JFTE9DQVRBQkxF
CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvaGVhZF8zMi5TIGIvYXJjaC94ODYva2Vy
bmVsL2hlYWRfMzIuUwppbmRleCBiY2VjZTkxLi5kN2NkZjViIDEwMDY0NAotLS0gYS9hcmNo
L3g4Ni9rZXJuZWwvaGVhZF8zMi5TCisrKyBiL2FyY2gveDg2L2tlcm5lbC9oZWFkXzMyLlMK
QEAgLTYwLDE2ICs2MCwxOCBAQAogI2RlZmluZSBQQUdFX1RBQkxFX1NJWkUocGFnZXMpICgo
cGFnZXMpIC8gUFRSU19QRVJfUEdEKQogI2VuZGlmCiAKKy8qIE51bWJlciBvZiBwb3NzaWJs
ZSBwYWdlcyBpbiB0aGUgbG93bWVtIHJlZ2lvbiAqLworTE9XTUVNX1BBR0VTID0gKCgoMTw8
MzIpIC0gX19QQUdFX09GRlNFVCkgPj4gUEFHRV9TSElGVCkKKwkKIC8qIEVub3VnaCBzcGFj
ZSB0byBmaXQgcGFnZXRhYmxlcyBmb3IgdGhlIGxvdyBtZW1vcnkgbGluZWFyIG1hcCAqLwot
TUFQUElOR19CRVlPTkRfRU5EID0gXAotCVBBR0VfVEFCTEVfU0laRSgoKDE8PDMyKSAtIF9f
UEFHRV9PRkZTRVQpID4+IFBBR0VfU0hJRlQpIDw8IFBBR0VfU0hJRlQKK01BUFBJTkdfQkVZ
T05EX0VORCA9IFBBR0VfVEFCTEVfU0laRShMT1dNRU1fUEFHRVMpIDw8IFBBR0VfU0hJRlQK
IAogLyoKICAqIFdvcnN0LWNhc2Ugc2l6ZSBvZiB0aGUga2VybmVsIG1hcHBpbmcgd2UgbmVl
ZCB0byBtYWtlOgotICogdGhlIHdvcnN0LWNhc2Ugc2l6ZSBvZiB0aGUga2VybmVsIGl0c2Vs
ZiwgcGx1cyB0aGUgZXh0cmEgd2UgbmVlZAotICogdG8gbWFwIGZvciB0aGUgbGluZWFyIG1h
cC4KKyAqIGEgcmVsb2NhdGFibGUga2VybmVsIGNhbiBsaXZlIGFueXdoZXJlIGluIGxvd21l
bSwgc28gd2UgbmVlZCB0byBiZSBhYmxlCisgKiB0byBtYXAgYWxsIG9mIGxvd21lbS4KICAq
LwotS0VSTkVMX1BBR0VTID0gKEtFUk5FTF9JTUFHRV9TSVpFICsgTUFQUElOR19CRVlPTkRf
RU5EKT4+UEFHRV9TSElGVAorS0VSTkVMX1BBR0VTID0gTE9XTUVNX1BBR0VTCiAKIElOSVRf
TUFQX1NJWkUgPSBQQUdFX1RBQkxFX1NJWkUoS0VSTkVMX1BBR0VTKSAqIFBBR0VfU0laRV9h
c20KIFJFU0VSVkVfQlJLKHBhZ2V0YWJsZXMsIElOSVRfTUFQX1NJWkUpCg==
--------------000508030907020100050601--
