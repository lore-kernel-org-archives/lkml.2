Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0CWIKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:10:45 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:37212 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0CWIKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=x-user-agent:content-type:mime-version:subject:from:date:to:cc
         :message-id;
        b=cOi84UOdlyAEm8k5nm/lShYhk/xkNeVDOchYeC7fG+ltDPR00HCzumsGfkskHsEoO1
         f8kjwhcfBTHTrPA9eSM/03wP696WflK7foPfUmY6O5v628L3PpM07eT2x8VGaXR1eZX+
         vCcqQ5yXB/VpplVmQWUJJGXnAmdR/tb0PyI1g=
X-User-Agent: K-9 Mail for Android
Content-Type: multipart/mixed; boundary="----VRY9KVIOYUY8CMBUIKJP5L52NYUB0L"
MIME-Version: 1.0
Subject: Re: [PATCH] S3C RTC driver: add support for S3C64xx
From: Maurus Cuelenaere <mcuelenaere@gmail.com>
Date: Tue, 23 Mar 2010 09:10:26 +0100
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Frans Pop <elendil@planet.nl>
Message-ID: <1277c835-b1f0-49b5-8009-f61afd7804f6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------VRY9KVIOYUY8CMBUIKJP5L52NYUB0L
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: base64

CgoiQW5kcmV3IE1vcnRvbiIgPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+IHdyb3RlOgoKPk9u
IE1vbiwgMjIgTWFyIDIwMTAgMTI6MjY6NDggKzAxMDAgTWF1cnVzIEN1ZWxlbmFlcmUgPG1jdWVs
ZW5hZXJlQGdtYWlsLmNvbT4gd3JvdGU6Cj4KPj4gQWRkIHN1cHBvcnQgZm9yIHRoZSBTM0M2NHh4
IFNvQyB0byB0aGUgZ2VuZXJpYyBTM0MgUlRDIGRyaXZlci4KPj4gCj4+IFNpZ25lZC1vZmYtYnk6
IE1hdXJ1cyBDdWVsZW5hZXJlIDxtY3VlbGVuYWVyZUBnbWFpbC5jb20+Cj4+IEFja2VkLUJ5OiBC
ZW4gRG9va3MgPGJlbi1saW51eEBmbHVmZi5vcmc+Cj4+IC0tLQo+PiAKPj4gVGhpcyB3YXMgc2Vu
dCB0byBydGMtbGludXggYmVmb3JlICgxMi8wMS8yMDEwKSwgYnV0IG5vIHJlc3BvbnNlIHdhcwo+
PiByZWNlaXZlZCB5ZXQuCj4+IFNlZSBodHRwOi8vZ3JvdXBzLmdvb2dsZS5jb20vZ3JvdXAvcnRj
LWxpbnV4L2Jyb3dzZV90aHJlYWQvdGhyZWFkLzJhMmRmYzIzYTgwNDJmM2QvMjgxMmRjYmFmZDlh
MGE4NQo+PiBmb3IgdGhlIGZ1bGwgdGhyZWFkLgo+PiAKPj4gQXQgMDgvMDMvMjAxMCBJIHBvc3Rl
ZCB0aGlzIHRvIExLTUwsIHdpdGggbm8gcmVzdWx0Lgo+PiBPbiByZWNvbW1lbmRhdGlvbiBvZiBG
cmFucyBQb3AsIEkgcmVzZW5kIHRoaXMgdG8gTEtNTCB3aXRoIEFuZHJldyBNb3J0b24gaW4gQ0Mu
Cj4+IAo+PiBUaGUgcGxhdGZvcm0gcGFydCBvZiB0aGlzIHBhdGNoIGhhcyBiZWVuIGluY2x1ZGVk
IGluIDIuNi4zNC1yYzIuCj4+IAo+PiAgYXJjaC9hcm0vcGxhdC1zM2MvaW5jbHVkZS9wbGF0L3Jl
Z3MtcnRjLmggfCAgICA0ICsKPgo+VGhhdCB3YXMgc25lYWt5LiAgSSBhc3N1bWUgdGhhdAo+YXJj
aC9hcm0vcGxhdC1zM2MvaW5jbHVkZS9wbGF0L3JlZ3MtcnRjLmggaXMgYSBzeW1saW5rIHRvCj5h
cmNoL2FybS9wbGF0LXNhbXN1bmcvaW5jbHVkZS9wbGF0L3JlZ3MtcnRjLmggb24geW91ciBtYWNo
aW5lIC0gaXQKPmRvZXNuJ3QgZXhpc3Qgb24gbWluZS4gIEkgZml4ZWQgdGhlIHBhdGNoIHNvIGl0
IHBhdGNoZXMgdGhlIGNvcnJlY3QKPnBhdGguCgpUaGF0J3MgY29ycmVjdCwgSSBwcm9iYWJseSBm
b3Jnb3QgdG8gdXBkYXRlIGl0IHdpdGggdGhlIHBsYXQtczNjIC0+IHBsYXQtc2Ftc3VuZyBtb3Zl
LCBzb3JyeSBhYm91dCB0aGF0LgoKPj4gIGRyaXZlcnMvcnRjL0tjb25maWcgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgMiArLQo+PiAgZHJpdmVycy9ydGMvcnRjLXMzYy5jICAgICAgICAgICAg
ICAgICAgICAgfCAgMTA3ICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tCj4+ICAzIGZpbGVz
IGNoYW5nZWQsIDkyIGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygtKQo+Cj5UaGUgcGF0Y2gg
aGFkIGEgYml0IG9mIHdvcmR3cmFwcGluZy4gIFBsZWFzZSB3YXRjaCBvdXQgZm9yIHRoZXNlIHRo
aW5ncwo+bmV4dCB0aW1lLgoKT2RkLCBJIHNwZWNpZmljYWxseSBkaWRuJ3QgdXNlIFRodW5kZXJi
aXJkIHRvIGVsaW1pbmF0ZSBhbnkgd29yZHdyYXBwaW5nLi4KCgpUaGFua3MgZm9yIGFjY2VwdGlu
ZyEKCi0tCk1hdXJ1cyBDdWVsZW5hZXJl

------VRY9KVIOYUY8CMBUIKJP5L52NYUB0L--

