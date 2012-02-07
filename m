Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab2BGAW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:22:27 -0500
Received: from a2-smtpout7.uol.com.br ([200.147.33.245]:38662 "EHLO
	smtps.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756370Ab2BGAWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:22:24 -0500
X-UOL-SMTP: SMTPS25
Date: Mon, 6 Feb 2012 22:21:42 -0200
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?M=C3=A1rcia?= Coutinho de Brito <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>, rui.zhang@intel.com
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
Message-ID: <20120207002116.GA22553@ime.usp.br>
References: <CAE9FiQXt4XbxBAaTQd156af_v0sEnkjO1YPK_Wd7+2i1rCKB0Q@mail.gmail.com>
 <CAE9FiQVUcPZOic1Vqw2Qyv138sk8OTQkVYeOCBPi+iDKvYH-hA@mail.gmail.com>
 <CAOtrxKM-M6yTKOwbiYqHqyRP-JvpAik8G7KYwGCX=2vAXe0T4Q@mail.gmail.com>
 <CAOtrxKNNdWYVFf3UWpKK6O7hK2PFSmfcBwaVD3UmNta00uYP4A@mail.gmail.com>
 <CAOtrxKPerDtHQgTOgb01Yzq8c=aoHEQM-GFE3c8Jo-XwX4Db-g@mail.gmail.com>
 <CAOtrxKO9kZce4sDopN4yKFtLVx-BQS56OwyEav0Bh1XjqnS1MQ@mail.gmail.com>
 <CAE9FiQU5239LD-e7FdpKq1iY3k80BFg2pLVw28YScufuai0R4w@mail.gmail.com>
 <CAOtrxKMb==2aR-BF2_XJy+y2_7JAhxHF2H60het19BQE163J8g@mail.gmail.com>
 <CAErSpo7wFda_6C7q9YLApJmRe8D=dnB4ks8VJ3UXQta_qm_8vA@mail.gmail.com>
 <CAErSpo5R7uAoN01zS2eMKPHJq3RF6mXN1d1j8C143ZuKziYEVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo5R7uAoN01zS2eMKPHJq3RF6mXN1d1j8C143ZuKziYEVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SIG5: b4db568e9b6cac244ba996c48ffd6a32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

On Feb 06 2012, Bjorn Helgaas wrote:
> On Thu, Jan 26, 2012 at 7:41 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Thu, Jan 26, 2012 at 4:16 AM, Rogério Brito <rbrito@ime.usp.br> wrote:
> >> On Thu, Jan 26, 2012 at 00:03, Yinghai Lu <yinghai@kernel.org> wrote:
> >>> 2012/1/25 Rogério Brito <rbrito@ime.usp.br>:
> >>>>
> >>>> Wild thoughts: I just saw that nouveau calls some ACPI stuff to get
> >>>> EDID information and, as ACPI is broken on this notebook, could that
> >>>> be a potential reason for the panic that I'm seeing? (Yes, I can take
> >>>> a photo of the screen).
> >>>
> >>> Which 2.6.x kernel works on your laptop without disabling acpi?
> >>
> >> Unfortunately, no 2.6 kernel has worked on this laptop without
> >> acpi=off. I also once booted FreeBSD here just to see how it would
> >> behave and it also hang with ACPI enabled.
> >>
> >> From what I see on this notebook, if ACPI is not turned off, the
> >> computer simply hangs once the ACPI is started (it gives one layman
> >> like me the impression of entering an infinite loop). But, again, this
> >> is just a layman observation of what the system appears to be doing.
> >
> > My guess is that most of these problems are related, so if we fixed
> > whatever causes the ACPI hang, the other problems would probably go
> > away, too.
> >
> > Did you figure out anything about the MTRRs?
> 
> Ping :)  Let me know if you'd like a patch to print out the MTRR info
> later in boot where it will be slow enough to capture in a video.

It's quite late here and I'm going to bed, but tomorrow I will send the
things that I collected so far (not much more, but still).


Thanks for the reminder,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
