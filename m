Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0L3KwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 05:52:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41455 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab0L3KwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 05:52:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: [Bug #24772] Crash with btrfs rootfs on dm-crypt [ kernel BUG at fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
Date: Thu, 30 Dec 2010 11:51:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <sV7shrPOroO.A.nPF.r-7GNB@chimera> <AANLkTi=Nik6dRiT2viiCHN6NR6OLApRZSk_z745hM0U8@mail.gmail.com>
In-Reply-To: <AANLkTi=Nik6dRiT2viiCHN6NR6OLApRZSk_z745hM0U8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301151.44702.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 30, 2010, Fabio Comolli wrote:
> Hi Rafael.
> I don't have linux on that laptop anymore.

OK, so I'm closing the bug as unreproducible.

Thanks,
Rafael


> On Thu, Dec 30, 2010 at 12:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=24772
> > Subject         : Crash with btrfs rootfs on dm-crypt [ kernel BUG at fs/btrfs/inode.c:806! ] on linux 2.6.37-rc5
> > Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> > Date            : 2010-12-10 20:30 (20 days old)
> > Message-ID      : <AANLkTi=j9zsaYNcu=NgGV=HfE-3rNHzVswov8VrgwjQp@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=129201308706568&w=2
> >
> >
> >
> 
> 

