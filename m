Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2AYATZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:19:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46254 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab2AYATX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:19:23 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKOjNwwAbuhrqTUdiV5M=790FwUetDTkMbRdbkR7bXNH4A@mail.gmail.com>
References: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
	<CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
	<CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
	<CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
	<CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
	<CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
	<20120113115946.GA10615@ime.usp.br>
	<CAE9FiQX_koTHsjP8w=FyiSaBgY6QnzyWD43AVUW1d4MzViJXCg@mail.gmail.com>
	<CAOtrxKN4FQSPUJpP47=4+XzjTpcOQj=Dy+MUWBVYu7mQHNaSXA@mail.gmail.com>
	<CAOtrxKM_ijORTP_5C4z0R79jy5O=_eX5iNJ_GmAqXf6d8OGe9g@mail.gmail.com>
	<CAE9FiQWbtByxJopU_SHLpiAJt_91qTs_=9dBFTYDHFh5OQQydg@mail.gmail.com>
	<CAOtrxKOy1msY_49GiVaaZ3GnORx8ifJYkiTjzDOe-Rk7LLD8rA@mail.gmail.com>
	<CAE9FiQV++kCaA-2Y0-zuR0NMzwcvd4LJ+5fdTECBPkZkhWD50Q@mail.gmail.com>
	<CAOtrxKNDTQVcg6wRJGxt_inva1YSDXG5YiO1EhH1Fs5ZDy+q3Q@mail.gmail.com>
	<CAE9FiQVPLQp+GzGsgON-nW6JKPE2_P6Aua8wHcgkOiLnhuJh4A@mail.gmail.com>
	<CAOtrxKNrMXkztu4Gtv_GFD_163fr18Au7DqyXEK-nacpu=-_eQ@mail.gmail.com>
	<CAOtrxKP6OQyf8TX8BYk+wTFNSZmLOZjHq-NBJqfnyh=PdAKSow@mail.gmail.com>
	<CAE9FiQWi5pMaKtyf_kwszO_m7fb15=d_2GpupNnSvbN61=X6bQ@mail.gmail.com>
	<CAOtrxKOjNwwAbuhrqTUdiV5M=790FwUetDTkMbRdbkR7bXNH4A@mail.gmail.com>
Date: Tue, 24 Jan 2012 16:19:22 -0800
X-Google-Sender-Auth: T0oRAm4kZ_GggDiLc7dEgPBxHiU
Message-ID: <CAE9FiQXt4XbxBAaTQd156af_v0sEnkjO1YPK_Wd7+2i1rCKB0Q@mail.gmail.com>
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
        Ram Pai <linuxram@us.ibm.com>, rui.zhang@intel.com
Content-Type: multipart/mixed; boundary=20cf300fac832edf6204b74f374d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf300fac832edf6204b74f374d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2012/1/24 Rog=E9rio Brito <rbrito@ime.usp.br>:
>> it seems not related. or could be ioremap etc have problem?
>>
>> So can you try to boot with nopat?
>
> I have experimented with Linux 3.3.0-rc1-00080-g16111ea, which is a merge=
 of:
>
> * yinghai's usb_smi_disable_early branch with HEAD =3D a3a6c096
> * linus's master branch with HEAD =3D 4a7cbb56
>
> I have booted the kernel as above, configured, as Yinghai asked, with
> OHCI disabled, but no other changes from the previous times. =A0I
> registered in video two boots with only a slight change in options
> passed to the kernel, with:
>
> 1 - http://youtu.be/fKYubKaNhuc being with options
> =A0 =A0`acpi=3Doff pnpbios=3Doff noapic debug ignore_loglevel pci=3Dearly=
dump
> boot_delay=3D10`
>
> 2 - http://youtu.be/Gll9RLfXS_c being with options
> =A0 =A0`acpi=3Doff pnpbios=3Doff noapic debug ignore_loglevel pci=3Dearly=
dump
> nopat boot_delay=3D10`
>
> The only change is the `nopat` option, as suggested by Yinghai.
>
> As you can see in the two videos, some things seem to have progressed:
> the kernel actually gets to boot, gets to mount/load the initramfs,
> passes things to init and, when it is loading things, I get a hang
> with a messed screen, as before.

Your bios does not have RAM page aligned...

[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)

assume that partial page is used SMI. let's leave the whole page alone for =
SMI

Can you please apply attached patch about e820 ram page alignement?

Thanks

Yinghai

--20cf300fac832edf6204b74f374d
Content-Type: text/x-patch; charset=US-ASCII; name="e820_ram_aligned.patch"
Content-Disposition: attachment; filename="e820_ram_aligned.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxtlrzlm0

U3ViamVjdDogW1BBVENIXSB4ODY6IEFsaWduIGU4MjAgcmFtIHJhbmdlIHRvIHBhZ2UKClNvbWUg
YmlvcyBwcm92aWRlZCBlODIwIHJhbSBlbnRyaWVzIGFyZSBub3QgcGFnZSBhbGlnbmVkLgoKVG8g
bWFrZSBsYXRlciBwcm9jZXNzaW5nIHNpbXBsZS4gV2UgY291bGQgcm91bmQgdXAgdGhvc2UgcmFu
Z2UgdG8KdG8gcGFnZSBhbGlnbmVkLgoKU2lnbmVkLW9mZi1ieTogWWluZ2hhaSBMdSA8eWluZ2hh
aUBrZXJuZWwub3JnPgoKLS0tCiBhcmNoL3g4Ni9rZXJuZWwvZTgyMC5jIHwgICA0NCArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDQ0
IGluc2VydGlvbnMoKykKCkluZGV4OiBsaW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwo9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwvZTgyMC5jCisrKyBs
aW51eC0yLjYvYXJjaC94ODYva2VybmVsL2U4MjAuYwpAQCAtODgwLDYgKzg4MCw0NyBAQCBzdGF0
aWMgaW50IF9faW5pdCBwYXJzZV9tZW1tYXBfb3B0KGNoYXIKIH0KIGVhcmx5X3BhcmFtKCJtZW1t
YXAiLCBwYXJzZV9tZW1tYXBfb3B0KTsKIAorc3RhdGljIHZvaWQgX19pbml0IGU4MjBfYWxpZ25f
cmFtX3BhZ2Uodm9pZCkKK3sKKwlpbnQgaTsKKwlib29sIGNoYW5nZWQgPSBmYWxzZTs7CisKKwlm
b3IgKGkgPSAwOyBpIDwgZTgyMC5ucl9tYXA7IGkrKykgeworCQlzdHJ1Y3QgZTgyMGVudHJ5ICpl
bnRyeSA9ICZlODIwLm1hcFtpXTsKKwkJdTY0IHN0YXJ0LCBlbmQ7CisJCXU2NCBzdGFydF9hbGln
bmVkLCBlbmRfYWxpZ25lZDsKKworCQlpZiAoZW50cnktPnR5cGUgIT0gRTgyMF9SQU0pCisJCQlj
b250aW51ZTsKKworCQlzdGFydCA9IGVudHJ5LT5hZGRyOworCQllbmQgPSBzdGFydCArIGVudHJ5
LT5zaXplOworCisJCXN0YXJ0X2FsaWduZWQgPSByb3VuZF91cChzdGFydCwgUEFHRV9TSVpFKTsK
KwkJZW5kX2FsaWduZWQgPSByb3VuZF9kb3duKGVuZCwgUEFHRV9TSVpFKTsKKworCQlpZiAoZW5k
X2FsaWduZWQgPD0gc3RhcnRfYWxpZ25lZCkgeworCQkJZTgyMF91cGRhdGVfcmFuZ2Uoc3RhcnQs
IGVuZCAtIHN0YXJ0LCBFODIwX1JBTSwgRTgyMF9SRVNFUlZFRCk7CisJCQljaGFuZ2VkID0gdHJ1
ZTsKKwkJCWNvbnRpbnVlOworCQl9CisJCWlmIChzdGFydCA8IHN0YXJ0X2FsaWduZWQpIHsKKwkJ
CWU4MjBfdXBkYXRlX3JhbmdlKHN0YXJ0LCBzdGFydF9hbGlnbmVkIC0gc3RhcnQsIEU4MjBfUkFN
LCBFODIwX1JFU0VSVkVEKTsKKwkJCWNoYW5nZWQgPSB0cnVlOworCQl9CisJCWlmIChlbmRfYWxp
Z25lZCA8IGVuZCkgeworCQkJZTgyMF91cGRhdGVfcmFuZ2UoZW5kX2FsaWduZWQsIGVuZCAtIGVu
ZF9hbGlnbmVkLCBFODIwX1JBTSwgRTgyMF9SRVNFUlZFRCk7CisJCQljaGFuZ2VkID0gdHJ1ZTsK
KwkJfQorCX0KKworCWlmIChjaGFuZ2VkKSB7CisJCXNhbml0aXplX2U4MjBfbWFwKGU4MjAubWFw
LCBBUlJBWV9TSVpFKGU4MjAubWFwKSwgJmU4MjAubnJfbWFwKTsKKwkJcHJpbnRrKEtFUk5fSU5G
TyAiYWxpZ25lZCBwaHlzaWNhbCBSQU0gbWFwOlxuIik7CisJCWU4MjBfcHJpbnRfbWFwKCJhbGln
bmVkIik7CisJfQorfQorCiB2b2lkIF9faW5pdCBmaW5pc2hfZTgyMF9wYXJzaW5nKHZvaWQpCiB7
CiAJaWYgKHVzZXJkZWYpIHsKQEAgLTg5Miw2ICs5MzMsOSBAQCB2b2lkIF9faW5pdCBmaW5pc2hf
ZTgyMF9wYXJzaW5nKHZvaWQpCiAJCXByaW50ayhLRVJOX0lORk8gInVzZXItZGVmaW5lZCBwaHlz
aWNhbCBSQU0gbWFwOlxuIik7CiAJCWU4MjBfcHJpbnRfbWFwKCJ1c2VyIik7CiAJfQorCisJLyog
SW4gY2FzZSwgV2UgaGF2ZSBSQU0gZW50cmVzIHRoYXQgYXJlIG5vdCBQQUdFIGFsaWduZWQgKi8K
KwllODIwX2FsaWduX3JhbV9wYWdlKCk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgY29uc3QgY2hhciAq
ZTgyMF90eXBlX3RvX3N0cmluZyhpbnQgZTgyMF90eXBlKQo=
--20cf300fac832edf6204b74f374d--
