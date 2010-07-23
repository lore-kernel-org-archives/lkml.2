Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab0GWULI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:11:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53815 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0GWULF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:11:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.35-rc6: Reported regressions from 2.6.34
Date: Fri, 23 Jul 2010 22:09:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <4C49A577.3020306@lwfinger.net>
In-Reply-To: <4C49A577.3020306@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007232209.54326.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 23, 2010, Larry Finger wrote:
> On 07/23/2010 06:42 AM, Rafael J. Wysocki wrote:
> > This message contains a list of some regressions from 2.6.34,
> > for which there are no fixes in the mainline known to the tracking team.
> > If any of them have been fixed already, please let us know.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
> > Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
> > Submitter	: Zdenek Kabelac<zdenek.kabelac@gmail.com>
> > Date		: 2010-06-28 9:40 (26 days old)
> > Message-ID	:<AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=127771804806465&w=2
> 
> I still have this in 2.6.35-rc5.

Thanks for the update.

Rafael
