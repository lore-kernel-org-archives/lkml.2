Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2AYBz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:55:27 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63554 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755627Ab2AYBzZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:55:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVUcPZOic1Vqw2Qyv138sk8OTQkVYeOCBPi+iDKvYH-hA@mail.gmail.com>
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
	<CAE9FiQXt4XbxBAaTQd156af_v0sEnkjO1YPK_Wd7+2i1rCKB0Q@mail.gmail.com>
	<CAE9FiQVUcPZOic1Vqw2Qyv138sk8OTQkVYeOCBPi+iDKvYH-hA@mail.gmail.com>
Date: Tue, 24 Jan 2012 23:55:24 -0200
X-Google-Sender-Auth: ZgqT8ts5cg1Hnxt87mrvB8-01eg
Message-ID: <CAOtrxKM-M6yTKOwbiYqHqyRP-JvpAik8G7KYwGCX=2vAXe0T4Q@mail.gmail.com>
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

Hi, people.

On Tue, Jan 24, 2012 at 22:57, Yinghai Lu <yinghai@kernel.org> wrote:
> 2012/1/24 Yinghai Lu <yinghai@kernel.org>:
>> 2012/1/24 Rogério Brito <rbrito@ime.usp.br>:
>>>> it seems not related. or could be ioremap etc have problem?
>>>>
>>>> So can you try to boot with nopat?
>>>
>>> I have experimented with Linux 3.3.0-rc1-00080-g16111ea, which is a merge of:
>>>
>>> * yinghai's usb_smi_disable_early branch with HEAD = a3a6c096
>>> * linus's master branch with HEAD = 4a7cbb56
>>>
>>> I have booted the kernel as above, configured, as Yinghai asked, with
>>> OHCI disabled, but no other changes from the previous times.  I
>>> registered in video two boots with only a slight change in options
>>> passed to the kernel, with:
>
> you really need disable_cardbus_mem1_pref.patch that i sent out before.

I thought that it was already in your git branch, but I applied it this time.

> also please try to boot with
> pci=nobios
>
> it will disable pci bios32 probing.

Did that (with both the disable_cardbus... and with e820_ram_aligned
patches applied), but I still got the same results. This was booting
with nopat and pci=nobios.

The next thing that I'm doing is recording a video of how the computer
boots when that transparent sizing bridge patch is reverted, so that
you can have that as a reference. Then, I will rip apart the ACPI
stuff from the configuration of the kernel to see if it is ACPI that
is getting in the way of something here.

I'm open to other suggestions.


Thanks,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
