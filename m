Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab2A0DmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:42:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40142 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab2A0DmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:42:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKMb==2aR-BF2_XJy+y2_7JAhxHF2H60het19BQE163J8g@mail.gmail.com>
References: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
 <20120108221342.GA7058@ime.usp.br> <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
 <20120109112207.7f993845@jbarnes-desktop> <CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
 <CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
 <CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
 <CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
 <CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
 <CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
 <20120113115946.GA10615@ime.usp.br> <CAE9FiQX_koTHsjP8w=FyiSaBgY6QnzyWD43AVUW1d4MzViJXCg@mail.gmail.com>
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
 <CAE9FiQU5239LD-e7FdpKq1iY3k80BFg2pLVw28YScufuai0R4w@mail.gmail.com> <CAOtrxKMb==2aR-BF2_XJy+y2_7JAhxHF2H60het19BQE163J8g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 26 Jan 2012 20:41:52 -0700
Message-ID: <CAErSpo7wFda_6C7q9YLApJmRe8D=dnB4ks8VJ3UXQta_qm_8vA@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>, rui.zhang@intel.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 4:16 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
> On Thu, Jan 26, 2012 at 00:03, Yinghai Lu <yinghai@kernel.org> wrote:
>> 2012/1/25 Rogério Brito <rbrito@ime.usp.br>:
>>>
>>> Wild thoughts: I just saw that nouveau calls some ACPI stuff to get
>>> EDID information and, as ACPI is broken on this notebook, could that
>>> be a potential reason for the panic that I'm seeing? (Yes, I can take
>>> a photo of the screen).
>>
>> Which 2.6.x kernel works on your laptop without disabling acpi?
>
> Unfortunately, no 2.6 kernel has worked on this laptop without
> acpi=off. I also once booted FreeBSD here just to see how it would
> behave and it also hang with ACPI enabled.
>
> From what I see on this notebook, if ACPI is not turned off, the
> computer simply hangs once the ACPI is started (it gives one layman
> like me the impression of entering an infinite loop). But, again, this
> is just a layman observation of what the system appears to be doing.

My guess is that most of these problems are related, so if we fixed
whatever causes the ACPI hang, the other problems would probably go
away, too.

Did you figure out anything about the MTRRs?

Bjorn
