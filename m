Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab2F1EKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:10:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33549 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2F1EKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:10:54 -0400
Message-ID: <4FEBD945.4050702@gmail.com>
Date: Wed, 27 Jun 2012 22:10:45 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>, Jovi Zhang <bookjovi@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: perf support user-space hw_breakpoint?
References: <CACV3sb+EqVR0Z7qtCOpFtmRS+7xvv0b4S0Jrk7o7b__89_WVcA@mail.gmail.com> <87bok7x0e1.fsf@sejong.aot.lge.com> <CACV3sbKJiORogfjjRfyFz4Vw7Re8EYZ7K+vuU6GCb5d7w=ZgzQ@mail.gmail.com> <87txxwxjmu.fsf@sejong.aot.lge.com>
In-Reply-To: <87txxwxjmu.fsf@sejong.aot.lge.com>
Content-Type: multipart/mixed;
 boundary="------------040709020102030502080502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040709020102030502080502
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/27/12 8:20 PM, Namhyung Kim wrote:
> NAK. This uses_mmap field is needed to setup per-task-per-cpu events for
> perf record (mostly). Without it, perf suffered from severe scalability
> issues. Maybe we can change it not to create per-task-per-cpu events iff
> for hwbp events only, but I'm not sure it's the right thing.
>
> Thanks,
> Namhyung

Add -a to the record command. And if you want to dump the samples try 
the attached.

David


--------------040709020102030502080502
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="perf-script-bp.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="perf-script-bp.patch"

ZGlmZiAtLWdpdCBhL3Rvb2xzL3BlcmYvYnVpbHRpbi1zY3JpcHQuYyBiL3Rvb2xzL3BlcmYv
YnVpbHRpbi1zY3JpcHQuYwppbmRleCA4ZTM5NWE1Li5lMzA5M2ExIDEwMDY0NAotLS0gYS90
b29scy9wZXJmL2J1aWx0aW4tc2NyaXB0LmMKKysrIGIvdG9vbHMvcGVyZi9idWlsdGluLXNj
cmlwdC5jCkBAIC0xMDksNiArMTA5LDE3IEBAIHN0YXRpYyBzdHJ1Y3QgewogCiAJCS5pbnZh
bGlkX2ZpZWxkcyA9IFBFUkZfT1VUUFVUX1RSQUNFLAogCX0sCisKKwlbUEVSRl9UWVBFX0JS
RUFLUE9JTlRdID0geworCQkudXNlcl9zZXQgPSBmYWxzZSwKKworCQkuZmllbGRzID0gUEVS
Rl9PVVRQVVRfQ09NTSB8IFBFUkZfT1VUUFVUX1RJRCB8CisJCQkgICAgICBQRVJGX09VVFBV
VF9DUFUgfCBQRVJGX09VVFBVVF9USU1FIHwKKwkJCSAgICAgIFBFUkZfT1VUUFVUX0lQICB8
IFBFUkZfT1VUUFVUX0FERFIgfAorCQkJCSAgUEVSRl9PVVRQVVRfU1lNIHwgUEVSRl9PVVRQ
VVRfRFNPLAorCisJCS5pbnZhbGlkX2ZpZWxkcyA9IFBFUkZfT1VUUFVUX1RSQUNFLAorCX0s
CiB9OwogCiBzdGF0aWMgYm9vbCBvdXRwdXRfc2V0X2J5X3VzZXIodm9pZCkKQEAgLTcyNyw2
ICs3MzgsOCBAQCBzdGF0aWMgaW50IHBhcnNlX291dHB1dF9maWVsZHMoY29uc3Qgc3RydWN0
IG9wdGlvbiAqb3B0IF9fdXNlZCwKIAkJCXR5cGUgPSBQRVJGX1RZUEVfVFJBQ0VQT0lOVDsK
IAkJZWxzZSBpZiAoIXN0cmNtcChzdHIsICJyYXciKSkKIAkJCXR5cGUgPSBQRVJGX1RZUEVf
UkFXOworCQllbHNlIGlmICghc3RyY21wKHN0ciwgImJwIikpCisJCQl0eXBlID0gUEVSRl9U
WVBFX0JSRUFLUE9JTlQ7CiAJCWVsc2UgewogCQkJZnByaW50ZihzdGRlcnIsICJJbnZhbGlk
IGV2ZW50IHR5cGUgaW4gZmllbGQgc3RyaW5nLlxuIik7CiAJCQlyYyA9IC1FSU5WQUw7CkBA
IC0xMTQ0LDcgKzExNTcsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG9wdGlvbiBvcHRpb25z
W10gPSB7CiAJCSAgICAiTG9vayBmb3IgZmlsZXMgd2l0aCBzeW1ib2xzIHJlbGF0aXZlIHRv
IHRoaXMgZGlyZWN0b3J5IiksCiAJT1BUX0NBTExCQUNLKCdmJywgImZpZWxkcyIsIE5VTEws
ICJzdHIiLAogCQkgICAgICJjb21tYSBzZXBhcmF0ZWQgb3V0cHV0IGZpZWxkcyBwcmVwZW5k
IHdpdGggJ3R5cGU6Jy4gIgotCQkgICAgICJWYWxpZCB0eXBlczogaHcsc3csdHJhY2UscmF3
LiAiCisJCSAgICAgIlZhbGlkIHR5cGVzOiBodyxzdyx0cmFjZSxyYXcsYnAuICIKIAkJICAg
ICAiRmllbGRzOiBjb21tLHRpZCxwaWQsdGltZSxjcHUsZXZlbnQsdHJhY2UsaXAsc3ltLGRz
bywiCiAJCSAgICAgImFkZHIsc3ltb2ZmIiwKIAkJICAgICBwYXJzZV9vdXRwdXRfZmllbGRz
KSwK
--------------040709020102030502080502--
