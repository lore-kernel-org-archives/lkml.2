Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2AYCdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 21:33:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53559 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab2AYCdR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 21:33:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKM-M6yTKOwbiYqHqyRP-JvpAik8G7KYwGCX=2vAXe0T4Q@mail.gmail.com>
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
	<CAOtrxKM-M6yTKOwbiYqHqyRP-JvpAik8G7KYwGCX=2vAXe0T4Q@mail.gmail.com>
Date: Wed, 25 Jan 2012 00:33:17 -0200
X-Google-Sender-Auth: j9VkZUmGThyxoe3Yl4rVQRKboqo
Message-ID: <CAOtrxKNNdWYVFf3UWpKK6O7hK2PFSmfcBwaVD3UmNta00uYP4A@mail.gmail.com>
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

Hi there, Yinghai, Linus, Bjorn and others.

On Tue, Jan 24, 2012 at 23:55, Rogério Brito <rbrito@ime.usp.br> wrote:
> The next thing that I'm doing is recording a video of how the computer
> boots when that transparent sizing bridge patch is reverted, so that
> you can have that as a reference. Then, I will rip apart the ACPI
> stuff from the configuration of the kernel to see if it is ACPI that
> is getting in the way of something here.

I started ripping things apart, first with the whole ACPI subsystem,
then with PM, with sound and I noticed that things always hung with
the nvidia watchdog/TCO module. So, I disabled it and the boot doesn't
hang there anymore. In fact, it goes further, and, for the first time
since I got my mother's notebook, the nouveau module was loaded.

Unfortunately, it died with a kernel panic and didn't reach the point
of X firing up.

So, there is something fishy indeed with these things.

Still open to sugestions. I will now compile a vanilla kernel from
Linus's tree gradually putting things in, but from what I already
talked with Bjorn, I think that ACPI will be a barrier (and it is sad
that so many things *don't* work with ACPI disabled).


Regards,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
