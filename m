Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab2ALFGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 00:06:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57369 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2ALFGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 00:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
References: <bug-41722-5003@https.bugzilla.kernel.org/>
	<201109062222.p86MMlK9023363@demeter2.kernel.org>
	<CAOtrxKO8+ukXovCiM+=c1EihbMFaYivmYnwDx4+41GggTEhyWg@mail.gmail.com>
	<CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
	<CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
	<CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
	<CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
	<CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
Date: Wed, 11 Jan 2012 21:06:51 -0800
X-Google-Sender-Auth: 5Aj0TO9Lz-MZMv6sSB2UxQoylu0
Message-ID: <CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: multipart/mixed; boundary=bcaec548a7295a846404b64db761
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec548a7295a846404b64db761
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2012 at 11:04 PM, Rog=E9rio Brito <rbrito@ime.usp.br> wrote=
:
> Hi, Yinghai.
>
> On Tue, Jan 10, 2012 at 03:07, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Jan 9, 2012 at 6:41 PM, Rog=E9rio Brito <rbrito@ime.usp.br> wrot=
e:
>> I have some pending patches that may fix bridge resource resizing.
>>
>> Can you try them at
>>
>> =A0 =A0 =A0git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-y=
inghai.git
>> for-pci2
>>
>> also please boot with "debug ignore_loglevel"
>
> Grabbing it right now. Will report it after I get some sleep (5AM here).

please try attached patch, it will fix one bios wrong setting.

>
>> BTW, did you try boot with "pci=3Duse_crs" and not with "acpi=3Doff" ?
>
> I tried, but I got a hang (both with Linux---many versions---and with
> FreeBSD). With Linux I get:
>
> =A0 http://www.ime.usp.br/~rbrito/linux/clevo/boot-without-acpi-off.jpg
>

need to work on that later.

Yinghai

--bcaec548a7295a846404b64db761
Content-Type: text/x-patch; charset=US-ASCII; name="disable_cardbus_mem1_pref.patch"
Content-Disposition: attachment; filename="disable_cardbus_mem1_pref.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxbb8ut00

U3ViamVjdDogW1BBVENIXSBQQ0k6IERpc2FibGUgY2FyZGJ1cyBicmlkZ2UgTUVNMSBwcmVmIENU
TAoKU29tZSBCSU9TIGVuYWJsZSBib3RoIHByZWYgZm9yIE1FTTAgYW5kIE1FTTEuCgpidXQgd2Ug
YXNzdW1lIE1FTTEgaXMgbm9uLXByZWYuLi4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlp
bmdoYWlAa2VybmVsLm9yZz4KCi0tLQogZHJpdmVycy9wY2kvc2V0dXAtYnVzLmMgfCAgICA4ICsr
KysrKysrCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspCgpJbmRleDogbGludXgtMi42
L2RyaXZlcnMvcGNpL3NldHVwLWJ1cy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2Ry
aXZlcnMvcGNpL3NldHVwLWJ1cy5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9wY2kvc2V0dXAtYnVz
LmMKQEAgLTc3NCw2ICs3NzQsMTQgQEAgc3RhdGljIHZvaWQgcGNpX2J1c19zaXplX2NhcmRidXMo
c3RydWN0CiAJaWYgKHJlYWxsb2NfaGVhZCkKIAkJYWRkX3RvX2xpc3QocmVhbGxvY19oZWFkLCBi
cmlkZ2UsIGJfcmVzKzEsIHBjaV9jYXJkYnVzX2lvX3NpemUsIDAgLyogZG9udCBjYXJlICovKTsK
IAorCS8qIE1FTTEgbXVzdCBub3QgYmUgcHJlZiBtbWlvICovCisJcGNpX3JlYWRfY29uZmlnX3dv
cmQoYnJpZGdlLCBQQ0lfQ0JfQlJJREdFX0NPTlRST0wsICZjdHJsKTsKKwlpZiAoY3RybCAmIFBD
SV9DQl9CUklER0VfQ1RMX1BSRUZFVENIX01FTTEpIHsKKwkJY3RybCAmPSB+UENJX0NCX0JSSURH
RV9DVExfUFJFRkVUQ0hfTUVNMTsKKwkJcGNpX3dyaXRlX2NvbmZpZ193b3JkKGJyaWRnZSwgUENJ
X0NCX0JSSURHRV9DT05UUk9MLCBjdHJsKTsKKwkJcGNpX3JlYWRfY29uZmlnX3dvcmQoYnJpZGdl
LCBQQ0lfQ0JfQlJJREdFX0NPTlRST0wsICZjdHJsKTsKKwl9CisKIAkvKgogCSAqIENoZWNrIHdo
ZXRoZXIgcHJlZmV0Y2hhYmxlIG1lbW9yeSBpcyBzdXBwb3J0ZWQKIAkgKiBieSB0aGlzIGJyaWRn
ZS4K
--bcaec548a7295a846404b64db761--
