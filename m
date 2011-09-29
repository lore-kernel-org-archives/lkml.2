Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1I2Jcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:32:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36493 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1I2Jcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:32:45 -0400
MIME-Version: 1.0
In-Reply-To: <201109291126.18470.rjw@sisk.pl>
References: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au>
	<201109282132.46887.rjw@sisk.pl>
	<CACVXFVM6CjZacbbvn0VzM78SNDa6geHSw1dsrCL1bbTBU=pH1g@mail.gmail.com>
	<201109291126.18470.rjw@sisk.pl>
Date: Thu, 29 Sep 2011 17:32:43 +0800
Message-ID: <CACVXFVOA486EvvymPchHB9V1WBLhsdFQRtr_zuOOo4HTbE0OKA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pm tree
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=002215b03162db165004ae113017
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--002215b03162db165004ae113017
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 29, 2011 at 5:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> But I don't think it is ugly, and this way is taken by BLOCK/PERF_EVENTS=
/
>> KGDB_KDB in kernel/trace/Makefile.
>
> You're right about this.
>
>> Also this one is a simple fix and don't introduce any new config option,
>> which is unnecessary.
>
> OK, I'll use your last patch. =A0Care to resend it with a sign-off?

OK, thanks, see attachment.

thanks,
--
Ming Lei

--002215b03162db165004ae113017
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-kernel-trace-Makefile-build-rpm-traces.c-only-if-CON.patch"
Content-Disposition: attachment; 
	filename="0001-kernel-trace-Makefile-build-rpm-traces.c-only-if-CON.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gt5jpevi0

RnJvbSBhNWEzNGFjMTc1ZTAyMjMxNDhiOWZlODA4OWM5OWUyNzg4MmNmMDI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8bWluZy5sZWlAY2Fub25pY2FsLmNvbT4KRGF0
ZTogV2VkLCAyOCBTZXAgMjAxMSAyMjo0MDowNiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIGtlcm5l
bC90cmFjZS9NYWtlZmlsZTogYnVpbGQgcnBtLXRyYWNlcy5jIG9ubHkgaWYKIENPTkZJR19QTV9S
VU5USU1FCgoKU2lnbmVkLW9mZi1ieTogTWluZyBMZWkgPG1pbmcubGVpQGNhbm9uaWNhbC5jb20+
Ci0tLQoga2VybmVsL3RyYWNlL01ha2VmaWxlIHwgICAgMiArKwogMSBmaWxlcyBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3RyYWNl
L01ha2VmaWxlIGIva2VybmVsL3RyYWNlL01ha2VmaWxlCmluZGV4IDU2YmRhYjUuLmY0OTQwNWYg
MTAwNjQ0Ci0tLSBhL2tlcm5lbC90cmFjZS9NYWtlZmlsZQorKysgYi9rZXJuZWwvdHJhY2UvTWFr
ZWZpbGUKQEAgLTUzLDcgKzUzLDkgQEAgZW5kaWYKIG9iai0kKENPTkZJR19FVkVOVF9UUkFDSU5H
KSArPSB0cmFjZV9ldmVudHNfZmlsdGVyLm8KIG9iai0kKENPTkZJR19LUFJPQkVfRVZFTlQpICs9
IHRyYWNlX2twcm9iZS5vCiBvYmotJChDT05GSUdfVFJBQ0VQT0lOVFMpICs9IHBvd2VyLXRyYWNl
cy5vCitpZmVxICgkKENPTkZJR19QTV9SVU5USU1FKSx5KQogb2JqLSQoQ09ORklHX1RSQUNFUE9J
TlRTKSArPSBycG0tdHJhY2VzLm8KK2VuZGlmCiBpZmVxICgkKENPTkZJR19UUkFDSU5HKSx5KQog
b2JqLSQoQ09ORklHX0tHREJfS0RCKSArPSB0cmFjZV9rZGIubwogZW5kaWYKLS0gCjEuNy41LjQK
Cg==
--002215b03162db165004ae113017--
