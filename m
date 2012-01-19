Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2ASQPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:15:34 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52446 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932171Ab2ASQPd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVPLQp+GzGsgON-nW6JKPE2_P6Aua8wHcgkOiLnhuJh4A@mail.gmail.com>
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
Date: Thu, 19 Jan 2012 14:15:32 -0200
X-Google-Sender-Auth: kRAFnuAv0IsdiHjTbEg5VGQbpLw
Message-ID: <CAOtrxKNrMXkztu4Gtv_GFD_163fr18Au7DqyXEK-nacpu=-_eQ@mail.gmail.com>
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

Hi, all.

On Thu, Jan 19, 2012 at 14:12, Yinghai Lu <yinghai@kernel.org> wrote:
> 2012/1/19 Rogério Brito <rbrito@ime.usp.br>:
>> If you want me to, say, recompile Linus's vanilla tree with only a few
>> selected patches, please let me know. I will now try to test some
>> other combinations of the options passed to the kernel.
>
> resource allocating for transparent bridge resizing works well and as expected.

OK.

> looks like quirk for usb hand off cause problem.
>
> can you try another branch in my tree?
>
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> usb_smi_disable_early

Sure, will do that right now.

> it will do usb hand off very early.
>
> you can do:
>
> mkdir linux-2.6 || exit -1
> cd linux-2.6
>
> git init-db
> # Add Linus's tree as a remote
> git remote add linus
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>
> git remote add yinghai
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>
> git remote update
>
> later will only do:
>
> git remote update
>
> git checkout -b rb_2012_01_19a linus/master
> git merge yinghai/usb_smi_disable_early

Will report ASAP. Thanks.


Regards,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
