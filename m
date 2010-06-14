Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0FNOMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:12:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33992 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab0FNOME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:12:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Kara <jack@suse.cz>
Subject: Re: [Bug #15909] open("a/",O_NOFOLLOW) fails with ELOOP if "a" is a symbolic link to a directory.
Date: Mon, 14 Jun 2010 16:10:31 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Marius Tolzmann <tolzmann@molgen.mpg.de>,
       Miklos Szeredi <mszeredi@suse.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.KL.C7OFMB@chimera> <20100614084331.GB3903@quack.suse.cz>
In-Reply-To: <20100614084331.GB3903@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141610.32134.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010, Jan Kara wrote:
> On Sun 13-06-10 16:48:58, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.33 and 2.6.34.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15909
> > Subject		: open("a/",O_NOFOLLOW) fails with ELOOP if "a" is a symbolic link to a directory.
> > Submitter	: Marius Tolzmann <tolzmann@molgen.mpg.de>
> > Date		: 2010-05-05 13:01 (40 days old)
> > Handled-By	: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> > 		  Jan Kara <jack@suse.cz>
> > Patch		: https://patchwork.kernel.org/patch/99291/
>   The fix went in shortly before 2.6.34 was released (commit
> 002baeecf53677d2034113e34197ec221f42e037). So everything should be fine.

Thanks, closing.

Rafael
