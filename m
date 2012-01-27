Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2A0GxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:53:19 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38279 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2A0GxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:53:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKMb==2aR-BF2_XJy+y2_7JAhxHF2H60het19BQE163J8g@mail.gmail.com>
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
	<CAOtrxKNNdWYVFf3UWpKK6O7hK2PFSmfcBwaVD3UmNta00uYP4A@mail.gmail.com>
	<CAOtrxKPerDtHQgTOgb01Yzq8c=aoHEQM-GFE3c8Jo-XwX4Db-g@mail.gmail.com>
	<CAOtrxKO9kZce4sDopN4yKFtLVx-BQS56OwyEav0Bh1XjqnS1MQ@mail.gmail.com>
	<CAE9FiQU5239LD-e7FdpKq1iY3k80BFg2pLVw28YScufuai0R4w@mail.gmail.com>
	<CAOtrxKMb==2aR-BF2_XJy+y2_7JAhxHF2H60het19BQE163J8g@mail.gmail.com>
Date: Thu, 26 Jan 2012 22:53:17 -0800
X-Google-Sender-Auth: zovz6TEhEI3lWqWn2SJU-c7AbFo
Message-ID: <CAE9FiQVROAqZYwdmMXJC22H3nmBzguZhP+86hfZG4k2=J7JUaA@mail.gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/26 Rogério Brito <rbrito@ime.usp.br>:
>
>> BTW, can you post you .config?
>
> Sure, it is here:
>
>    http://www.ime.usp.br/~rbrito/linux/clevo/linux-configs/config-3.2.0-rc5-12270-g6fe13a6-yinghai

are you sure ?

your dmesg is 32bit

http://www.ime.usp.br/~rbrito/linux/clevo/2012-01-13-0951-yanghai-for-pci2-branch/dmesg-3.2.0-rc5+.txt

and this config is 64bit.

Yinghai
