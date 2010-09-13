Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0IMR4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:56:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51031 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab0IMR4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:56:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Kara <jack@suse.cz>
Subject: Re: [Bug #16312] WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
Date: Mon, 13 Sep 2010 19:56:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera> <p44oKaOqEDM.A.QHG.AjSjMB@chimera> <20100913114229.GA4016@quack.suse.cz>
In-Reply-To: <20100913114229.GA4016@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131956.03639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 13, 2010, Jan Kara wrote:
>   Hi,
> 
> On Sun 12-09-10 21:08:40, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
> > Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
> > Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Date		: 2010-06-28 9:40 (77 days old)
> > Message-ID	: <AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=127771804806465&w=2
> > 		  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/00884.html
> > Handled-By	: Jan Kara <jack@suse.cz>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=27272
>   Sorry, it isn't fixed yet. Christoph wanted to do the patch a bit
> differently and I was busy with other work...

OK, thanks for the update.

Rafael
