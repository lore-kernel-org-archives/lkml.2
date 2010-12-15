Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0LOWR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:17:27 -0500
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:38884 "HELO
	web31806.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751869Ab0LOWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:17:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=gkkEJENHyDBFHfzJ+nMQK8X+RBRFUK6Mgn/fxtQ21+y2b02JK81VQyORbO1ud7WPrmYKXuxlGcrAsmM+WqsdjjPGbN6A/EwlhGzNpnUW7mLm1lCz5aoTkUFu8JMAPi4Lu9eV4DygOj0u5OXXqV9KdSyFOP2q77VeZlpTIWD5NpI=;
Message-ID: <328967.74245.qm@web31806.mail.mud.yahoo.com>
X-YMail-OSG: jslY5NIVM1mBT4cANPWnqrCEZKU25JbrTFhEbTpFBCYJgdu
 7839EASFJPraJjcRMVwIQ80lAKgmOucXqx7mGIXpQxxc2dEOgHF2MTVYHmjv
 o1_ByOdC7nqC2.IqGqPrEeYIOL8ciBt_Csv_lbaO9qtPmHa_UoV_GRAHhfhx
 sdPlAkkZ0Esftqke2keTPCq6QnwuOObvnkva815M_Yp37YF.HHXfh.eoatpQ
 HHZiP9uhfrYXISA580xbMQcCYrH0WgVI9XE0.y7AaNBwtBvsZKCmZIEKitVO
 C_83Um9ennp3zR8hWOaaQqgxR9zhYDzqSvUzqNGUMSLJbiNnVP3RUheqnzN3
 83q4bK7xbHyQc.UwlVkSkOqFiH0K.0pB1Whr1YO88EysrmvbMuQ2ouoikpcj
 FBLr62qrUZ.2n
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.108.291010
Date: Wed, 15 Dec 2010 14:17:21 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Ben Gamari <bgamari@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <87fwu05imn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 12/14/10, Ben Gamari <bgamari@gmail.com> wrote:
> > > Your driver may be the best on the planet - who
> knows - 
> > Obviously he didn't review it.
> 
> This is may be true, perhaps he didn't look at the code.

"may be true". It is clear he didn't. What he wrote is quoted above.

> This is not
> because he doesn't have confidence that your driver is
> well-written or
> holds a grudge against you.

Have you been authorized to speak for him?

> The reason for this NAK is
> policy: a driver
> already exists. In the kernel we work with what already
> exists, even if
> it may be more difficult than the alternative.

Nothing can be further from the truth. If you have been long enough around Linux, you'd know that many times there would be two perfectly working drivers for the same device with hundreds of thousands of those devices out in the wild, in the kernel. You'd also know that sometimes a driver is submitted and accepted and in the kernel, but it is so badly written that it gets re-written by one of the resident "linux kernel engineers" and then the latter driver replaces the one already existing, etc, etc. Add to this that it is sometimes good to offer people a choice between a defunct and unmaintained driver and a working and maintained driver.

Now is the time to do the right thing and get a working and technically correct UAS driver, when there are no UAS devices out there.

> I looked at your code; from my uninformed perspective it
> looks very
> nice. You clearly do have a good understanding of the stack
> and your
> code looks refreshingly clean. That being said, a driver
> covering the
> same devices already exists in the tree. There may be good
> technical
> reasons why this driver is inferior, but these are merely
> reasons to fix
> the existing code, not rip it out to be replaced
> wholesale.

It's much easier, faster and foolproof to rip out a defunct driver than to submit 30+ patches that change 100% of the driver. Moreover when there are no devices for it yet.

> At this point you have two options: You can continue to
> argue that the
> world is against you,

I don't argue that nor do I think that.

> which as we seen makes neither side
> happy and only
> makes your life as a contributor harder, or you can try to
> work what you
> have into something that will fit with the existing
> codebase. I suggest
> the latter. Further arguing is not going to change this
> policy. That
> being said, your expertise is certainly needed and it is in
> everyone's
> best interest to ensure that the UAS driver in the kernel
> is the best
> that it can be.

The situation is as follows: the Linux band is more than happy to review patches to /their/ code, but when you submit a driver that replaces a defunct driver of theirs in the kernel, then all of a sudden no one can read code to give a technical review of your driver.  So they say "we're happy to accept patches to /our/ code even if it replaces 100% of it, but your driver which does this in one go is rejected, sorry" and "I've no idea if it is good or bad".

> Improving code is very useful.

Improving code can be useful, but not to the extent of replacing it 100% in one go in 30+ patches.

A patch is supposed to fix a single bug or a feature missed, etc. For example see my recent patches posted as well as examine git history, as well as examine my patches from before there was git (starting with the SCSI layer using the slab cache for struct scsi_cmnd allocation).

> History has taught us that
> flat-out
> rewriting components just makes things messier.

Nothing can be further from the truth. This isn't a whimsical rewrite. I tried to "fix" uas.c but it's just horrible and needs to be ripped out.  Just one patch of mine changed 86% of the code and that's NOT right. But with that defunct driver, there was just no other way. The terminology the driver uses show the writer is not familiar with the technology. The logistical flow of the code shows the writer isn't familiar with the way a SCSI Delivery Subsystem works, UAS and USB in general. I've outlined that in my 18 technical point review earlier in this thread.

The right thing was to write a UAS driver that is correct and that it works, thus uasp.c.

> He apologized because he knows you put a lot of time,
> effort, and

Again, you speak for other people. This isn't a good thing.

> thought into a piece of code which we cannot accept.

"we"? See when you write emails here, and pretend to be this benevolent selfless creature lacking all self-interest, you have to be more subtle and present an unbiased opinion. Using "we" isn't the way to do it.

> It is
> unfortunate
> that this is the case but such is the reality of
> large-scale software
> development.

uasp.c is 1141 lines, a featherweight in drivers class. There is no "large-scale software development". uasp.c is self-contained driver. It doesn't change or modify any of the rest of the kernel. So now you can see how there is NO "large-scale software development".  It doesn't affect the system other than when uasp.c is used people will notice that they can now use a UAS device.

> Easy question. See above. In short, there is no sense to
> give a
> technical review of code which we ultimately won't be able
> use.

You said it: "ultimately won't be able to use". Basically a decision has already been made. And here you have shown the problem: the biased opinion of the Linux band: you're welcome to improve /our/ code even it you completely replace it in one go in 30+ patches, but we're not accepting your driver, under any circumstances.  How about give people a choice?

> Sometimes this sort of thing happens. If I were you, I
> would accept what
> people have been telling you and try to integrate portions
> of your

People? You mean a two people who have known each other for over 10 years are close knit friends who work for the same company whose company sponsors their conferences and gives them equipment.

> patch into the existing UAS driver. This will cause the
> least pain/most
> benefit to all involved.

The least pain/most benefit is to replace the defunct uas.c with uasp.c, so people can test the UAS devices they are developing and when those devices are released on the market, people can use them.  See here: http://marc.info/?l=linux-scsi&m=129227488508299&w=2

   Luben

