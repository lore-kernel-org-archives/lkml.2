Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1LWSYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 13:24:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34976 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1LWSY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 13:24:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAPbh3rt_Fj-OcuH1mry3aUGQa+rc-t273KtWLSiQGpN1i2FtCQ@mail.gmail.com>
References: <20111215210538.GA12248@konrad-lan>
	<CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
	<20111216000716.GA14822@suse.de>
	<CAE9FiQWufpJ7LwNiBnpS9bR_Sk4e5=wNZp2NmKp117+i56h=Sg@mail.gmail.com>
	<CAE9FiQXsnc5FqbhPaZLsFbZa1zz44M8k-9yP-ow814oPEEDhjQ@mail.gmail.com>
	<20111217144206.GF14816@konrad-lan>
	<CAE9FiQUvAv59UeCAyJ2h9swVmsbB6FqHzzThhbOhmvEag3WkRQ@mail.gmail.com>
	<CAPbh3rt_Fj-OcuH1mry3aUGQa+rc-t273KtWLSiQGpN1i2FtCQ@mail.gmail.com>
Date: Fri, 23 Dec 2011 10:24:28 -0800
X-Google-Sender-Auth: VfOVGymJpkbkuZFzXVHJ8DnGBp8
Message-ID: <CAE9FiQUj6-OwjfeOzWDUufTy9DhkTvbVkmQeQLCW40RsUyRuaw@mail.gmail.com>
Subject: Re: [GIT PULL] ibft fix for 3.2-rc6
From: Yinghai Lu <yinghai@kernel.org>
To: konrad@darnok.org
Cc: Greg KH <gregkh@suse.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Content-Type: multipart/mixed; boundary=20cf3040e986004cbb04b4c687a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf3040e986004cbb04b4c687a4
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Dec 22, 2011 at 7:50 PM, Konrad Rzeszutek Wilk
<konrad@darnok.org> wrote:
>>
>> When legacy mode iscsi installation is used, installation program will
>> not need user install those info again.
>>
>> QA are complaining that difference.
>
> I think I understand your position. You are getting emails from QA
> testing some hardware saying it does not work with RHEL, so you try
> upstream, find the bug and fix it (awesome, thanks for doing that),
> and then you want to back-port the fix so RHEL picks it up (and can
> close the bug). Thr mechanism for that is by contacting the vendor
> about this - either using the Program Manager to open a feature
> request, or waiting for a customer to report this bug (on the Red Hat
> side) and then your fix will be magically picked up.

yes,

attached is the patch for 2.6.32 to close the loop.

Thanks

Yinghai

--20cf3040e986004cbb04b4c687a4
Content-Type: text/x-patch; charset=US-ASCII; name="fix_ibft_checking_2.6.32.patch"
Content-Disposition: attachment; filename="fix_ibft_checking_2.6.32.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwjj49950

W1BBVENIIC12Mi42LjMyXSBpYmZ0OiBGaW5kaW5nIElCRlQgQUNQSSB0YWJsZSBvbiBVRUZJCgpj
b21taXQgOTM1YTlmZWU1MWM5NDViODk0MmJlMmQ3YjRiYWUwNjkxNjdiNDg4NiB1cHN0cmVhbS4K
CkZvdW5kIG9uZSBzeXN0ZW0gd2l0aCBVRUZJL2lCRlQsIGtlcm5lbCBkb2VzIG5vdCBkZXRlY3Qg
dGhlIGlCRlQgZHVyaW5nCmlzY3NpX2liZnQgbW9kdWxlIGxvYWRpbmcuCgpTbyB1c2VycyB3aWxs
IG5lZWQgdG8gaW5wdXQgaXNjc2kgaW5mbyBkdXJpbmcgUkhFTCA2LnggaW5zdGFsbGF0aW9uLgoK
V2UgY2FuIGFkZCBjaGVja2luZyBpbiBpYmZ0X2luaXQgZm9yIGFjcGkuCgpBdCB0aGF0IHRpbWUg
QUNQSSBpQkZUIGFscmVhZHkgZ2V0IHBlcm1hbmVudCBtYXBwZWQgd2l0aCBpb3JlbWFwLgoKRm9y
IGxlZ2FjeSBvbmUsIHByaW50IHRoZSBmb3VuZCBhZGRyZXNzIGVhcmx5LgoKClNpZ25lZC1vZmYt
Ynk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9maXJtd2Fy
ZS9pc2NzaV9pYmZ0LmMgfCAgIDQyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKystLQogMSBmaWxlIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0p
CgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvZmlybXdhcmUvaXNjc2lfaWJmdC5jCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvZmlybXdhcmUvaXNjc2lfaWJmdC5jCisrKyBs
aW51eC0yLjYvZHJpdmVycy9maXJtd2FyZS9pc2NzaV9pYmZ0LmMKQEAgLTkyNiw2ICs5MjYsMzcg
QEAgc3RhdGljIGludCBfX2luaXQgaWJmdF9yZWdpc3Rlcl9hdHRyaWJ1dAogCXJldHVybiByYzsK
IH0KIAorI2lmZGVmIENPTkZJR19BQ1BJCitzdGF0aWMgY29uc3Qgc3RydWN0IHsKKwljaGFyICpz
aWduOworfSBpYmZ0X3NpZ25zW10gPSB7CisJLyoKKwkgKiBPbmUgc3BlYyBzYXlzICJJQkZUIiwg
dGhlIG90aGVyIHNheXMgImlCRlQiLiBXZSBoYXZlIHRvIGNoZWNrCisJICogZm9yIGJvdGguCisJ
ICovCisJeyBBQ1BJX1NJR19JQkZUIH0sCisJeyAiaUJGVCIgfSwKK307CisKK3N0YXRpYyB2b2lk
IF9faW5pdCBhY3BpX2ZpbmRfaWJmdF9yZWdpb24odm9pZCkKK3sKKwlpbnQgaTsKKwlzdHJ1Y3Qg
YWNwaV90YWJsZV9oZWFkZXIgKnRhYmxlID0gTlVMTDsKKworCWlmIChhY3BpX2Rpc2FibGVkKQor
CQlyZXR1cm47CisKKwlmb3IgKGkgPSAwOyBpIDwgQVJSQVlfU0laRShpYmZ0X3NpZ25zKSAmJiAh
aWJmdF9hZGRyOyBpKyspIHsKKwkJYWNwaV9nZXRfdGFibGUoaWJmdF9zaWduc1tpXS5zaWduLCAw
LCAmdGFibGUpOworCQlpYmZ0X2FkZHIgPSAoc3RydWN0IGFjcGlfdGFibGVfaWJmdCAqKXRhYmxl
OworCX0KK30KKyNlbHNlCitzdGF0aWMgdm9pZCBfX2luaXQgYWNwaV9maW5kX2liZnRfcmVnaW9u
KHZvaWQpCit7Cit9CisjZW5kaWYKKwogLyoKICAqIGliZnRfaW5pdCgpIC0gY3JlYXRlcyBzeXNm
cyB0cmVlIGVudHJpZXMgZm9yIHRoZSBpQkZUIGRhdGEuCiAgKi8KQEAgLTkzNyw5ICs5NjgsMTYg
QEAgc3RhdGljIGludCBfX2luaXQgaWJmdF9pbml0KHZvaWQpCiAJaWYgKCFpYmZ0X2tzZXQpCiAJ
CXJldHVybiAtRU5PTUVNOwogCisJLyoKKwkgICBBcyBvbiBVRUZJIHN5c3RlbXMgdGhlIHNldHVw
X2FyY2goKS9maW5kX2liZnRfcmVnaW9uKCkKKwkgICBpcyBjYWxsZWQgYmVmb3JlIEFDUEkgdGFi
bGVzIGFyZSBwYXJzZWQgYW5kIGl0IG9ubHkgZG9lcworCSAgIGxlZ2FjeSBmaW5kaW5nLgorCSov
CisJaWYgKCFpYmZ0X2FkZHIpCisJCWFjcGlfZmluZF9pYmZ0X3JlZ2lvbigpOworCiAJaWYgKGli
ZnRfYWRkcikgewotCQlwcmludGsoS0VSTl9JTkZPICJpQkZUIGRldGVjdGVkIGF0IDB4JWxseC5c
biIsCi0JCSAgICAgICAodTY0KWlzYV92aXJ0X3RvX2J1cyhpYmZ0X2FkZHIpKTsKKwkJcHJfaW5m
bygiaUJGVCBkZXRlY3RlZC5cbiIpOwogCiAJCXJjID0gaWJmdF9jaGVja19kZXZpY2UoKTsKIAkJ
aWYgKHJjKQo=
--20cf3040e986004cbb04b4c687a4--
