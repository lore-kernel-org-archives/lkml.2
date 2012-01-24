Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab2AXWSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:18:10 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56105 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185Ab2AXWSI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWi5pMaKtyf_kwszO_m7fb15=d_2GpupNnSvbN61=X6bQ@mail.gmail.com>
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
Date: Tue, 24 Jan 2012 20:18:05 -0200
X-Google-Sender-Auth: d3aevSg_jTBdzQQmDlt3f_inyc0
Message-ID: <CAOtrxKOjNwwAbuhrqTUdiV5M=790FwUetDTkMbRdbkR7bXNH4A@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?M=C3=A1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>, rui.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Yinghai, Bjorn, Ram, Linus and other people,

On Thu, Jan 19, 2012 at 17:48, Yinghai Lu <yinghai@kernel.org> wrote:
> 2012/1/19 Rogério Brito <rbrito@ime.usp.br>:
>>
>> OK, now it seems that we are getting farther. The system boots, even
>> mounts the root filesystem, udev starts and, then, when it seems that
>> some USB messages are going to appear on the screen, the notebook
>> crashes with the same distortion that happened before (with some of
>> the last messages appearing being related to OHCI).
>
> in that case, Can you try to disable OHCI in .config
>
> CONFIG_USB_OHCI_HCD
>
> OHCI controller 00:0b.0 is using
> Memory at b0004000 (32-bit, non-prefetchable) [size=4K]
>
> VGA controller 00:05.0
>        Memory at b2000000 (32-bit, non-prefetchable) [size=16M]
>        Memory at c0000000 (64-bit, prefetchable) [size=256M]
>        Memory at b1000000 (64-bit, non-prefetchable) [size=16M]
>        [virtual] Expansion ROM at 80000000 [disabled] [size=128K]
>
> it seems not related. or could be ioremap etc have problem?
>
> So can you try to boot with nopat?

I have experimented with Linux 3.3.0-rc1-00080-g16111ea, which is a merge of:

* yinghai's usb_smi_disable_early branch with HEAD = a3a6c096
* linus's master branch with HEAD = 4a7cbb56

I have booted the kernel as above, configured, as Yinghai asked, with
OHCI disabled, but no other changes from the previous times.  I
registered in video two boots with only a slight change in options
passed to the kernel, with:

1 - http://youtu.be/fKYubKaNhuc being with options
    `acpi=off pnpbios=off noapic debug ignore_loglevel pci=earlydump
boot_delay=10`

2 - http://youtu.be/Gll9RLfXS_c being with options
    `acpi=off pnpbios=off noapic debug ignore_loglevel pci=earlydump
nopat boot_delay=10`

The only change is the `nopat` option, as suggested by Yinghai.

As you can see in the two videos, some things seem to have progressed:
the kernel actually gets to boot, gets to mount/load the initramfs,
passes things to init and, when it is loading things, I get a hang
with a messed screen, as before.

Among other things, one thing took my attention, which were some messages like:

    ACPI Exception: AE_BAD_PARAMETER, Thread 9340 could not acquire
Mutex [0x1] (20120111/utmutex-276)

which seems strange, particularly as I passed the option `acpi=off` to
my kernel.

I don't know if that's a red herring or not. I can perform other
tests, of course.


Thanks as usual,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
