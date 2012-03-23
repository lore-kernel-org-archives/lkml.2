Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab2CWMwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:52:03 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53888 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CWMwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkjZszURpgoJFevRHcDwXzgjAHaryfjsrb9Gx8d7ttK=SQ@mail.gmail.com>
References: <CAKgNAkhiHKHSJofXNjCx-NTajzZ5L5Ak_y3YereSJn8dwE=npA@mail.gmail.com>
 <201203170116.11342.vda.linux@googlemail.com> <CAKgNAkjZszURpgoJFevRHcDwXzgjAHaryfjsrb9Gx8d7ttK=SQ@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 23 Mar 2012 13:51:38 +0100
Message-ID: <CAK1hOcPVYcJan5=fbhz3T0FRZOwGUpFVxfY45r9ST50MqOpk7Q@mail.gmail.com>
Subject: Re: man-pages-3.37 is released
To: mtk.manpages@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8f23529780448204bbe87db9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f23529780448204bbe87db9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Mon, Mar 19, 2012 at 7:29 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On Sat, Mar 17, 2012 at 1:16 PM, Denys Vlasenko
> <vda.linux@googlemail.com> wrote:
>> On Friday 09 March 2012 18:27, Michael Kerrisk (man-pages) wrote:
>>> ptrace.2
>>> =A0 =A0 Denys Vlasenko =A0[Oleg Nesterov, Tejun Heo]
>>> =A0 =A0 =A0 =A0 add extended description of various ptrace quirks
>>
>> Pulled current git and spotted a few broken places.
>
> I made a few light edits to your patch, but basically applied it as
> given for man-pages-3.38.

Thanks! I found one tiny markup bug.

Also, I want to add info about PTRACE_GETEVENTMSG on
PTRACE_EVENT_EXEC. We document PTRACE_GETEVENTMSG
on all other PTRACE_EVENT_foo's, except EXEC.
That's not fair :)

Please find the patch attached.

--=20
vda

--e89a8f23529780448204bbe87db9
Content-Type: text/x-patch; charset=US-ASCII; name="ptrace.2.diff"
Content-Disposition: attachment; filename="ptrace.2.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h0589is61

ZGlmZiAtLWdpdCBhL21hbjIvcHRyYWNlLjIgYi9tYW4yL3B0cmFjZS4yCmluZGV4IDVhOGI2NDgu
LjBlN2NhMDggMTAwNjQ0Ci0tLSBhL21hbjIvcHRyYWNlLjIKKysrIGIvbWFuMi9wdHJhY2UuMgpA
QCAtMzc0LDYgKzM3NCwxMCBAQCB2YWx1ZSBzdWNoIHRoYXQKICAgc3RhdHVzPj44ID09IChTSUdU
UkFQIHwgKFBUUkFDRV9FVkVOVF9FWEVDPDw4KSkKIC5maQogCitJZiBleGVjaW5nIHRocmVhZCBp
cyBub3QgYSB0aHJlYWQgZ3JvdXAgbGVhZGVyLCB0aHJlYWQgSUQKK2lzIHJlc2V0IHRvIHRocmVh
ZCBncm91cCBsZWFkZXIncyBJRCBiZWZvcmUgdGhpcyBzdG9wLgorU2luY2UgTGludXggMy4wLCB0
aGUgZm9ybWVyIHRocmVhZCBJRCBjYW4gYmUgcmV0cmlldmVkIHdpdGgKKy5CUiBQVFJBQ0VfR0VU
RVZFTlRNU0cgLgogLlRQCiAuQlIgUFRSQUNFX09fVFJBQ0VWRk9SS0RPTkUgIiAoc2luY2UgTGlu
dXggMi41LjYwKSIKIFN0b3AgdGhlIHRyYWNlZSBhdCB0aGUgY29tcGxldGlvbiBvZiB0aGUgbmV4
dApAQCAtMTAxOCw2ICsxMDIyLDkgQEAgY2FuIGJlIHVzZWQgdG8gcmV0cmlldmUgdGhlIG5ldyB0
aHJlYWQncyBJRC4KIC5CIFBUUkFDRV9FVkVOVF9FWEVDCiBTdG9wIGJlZm9yZSByZXR1cm4gZnJv
bQogLkJSIGV4ZWN2ZSAoMikuCitTaW5jZSBMaW51eCAzLjAsCisuQlIgUFRSQUNFX0dFVEVWRU5U
TVNHCityZXR1cm5zIHRoZSBmb3JtZXIgdGhyZWFkIElELgogLlRQCiAuQiBQVFJBQ0VfRVZFTlRf
RVhJVAogU3RvcCBiZWZvcmUgZXhpdCAoaW5jbHVkaW5nIGRlYXRoIGZyb20KQEAgLTEwMzksNyAr
MTA0Niw4IEBAIHRvIGZpbmlzaCBleGl0aW5nLgogb24KIC5CIFBUUkFDRV9FVkVOVAogc3RvcHMg
cmV0dXJucwotLkIgU0lHVFJBUCBpbgorLkIgU0lHVFJBUAoraW4KIC5JUiBzaV9zaWdubyAsCiB3
aXRoCiAuSSBzaV9jb2RlCg==
--e89a8f23529780448204bbe87db9--
