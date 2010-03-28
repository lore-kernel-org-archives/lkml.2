Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0C1Ltq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:49:46 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:34951 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab0C1Lto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=q9VQbBos8Qr50EnBvbMFfZSM5et+jypyi2TNG4oQeC6SuGWAPP4Wsq6zmzE3Db6W5x
         mNoPyO+9KVyUBi1NYozoHoVcvWcrbQ1I85ARoko0l3TLEmDOrIRIXOalZO9C0ePh3Q/N
         0sAeArkMPIYN6GSq0DtwRTaSKsrUmEvc9xuHo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: 2.6.34-rc2 breaks via82cxxx Host Protected Area
Date: Sun, 28 Mar 2010 13:48:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, david@fries.net, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4BAD5472.9050303@garzik.org> <201003271634.08054.bzolnier@gmail.com> <20100328140141.f4a86697.sfr@canb.auug.org.au>
In-Reply-To: <20100328140141.f4a86697.sfr@canb.auug.org.au>
MIME-Version: 1.0
Message-Id: <201003281348.00697.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephen,

On Sunday 28 March 2010 05:01:41 am Stephen Rothwell wrote:
> Hi Bart,
> 
> On Sat, 27 Mar 2010 16:34:08 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> > On Saturday 27 March 2010 03:44:34 pm David Miller wrote:
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Date: Sat, 27 Mar 2010 11:19:53 +0100
> > > 
> > > > The commit itself may also have a problem but since it was _never_ in
> > > > linux-next tree it never saw a wider upstream testing.
> > > 
> > > This is not true Bart.
> > 
> > Uh?  I had verified my claims before writing previous mail..
> > 
> > The patch ("via82cxxx: workaround h/w bugs") appeared in Linus'
> > tree on 19th January and it was neither in next-20100101 nor in
> > next-20100119.. etc.
> 
> That commit first appeared in linux-next in next-20100120 as part of
> Dave's ide tree.  It was merged into Linus' tree on March 5th (commit
> 4c10c937cc2eb197db565392db91d429eec71176 "Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide-next-2.6").

Which doesn't change a bit the fundamental fact that the patch was not
meant for upstream by me and was clearly marked as such.  If David wanted
it upstream he should either be ready to provide support for it himself
or solve it in a more formal way..

--
Bartlomiej Zolnierkiewicz
