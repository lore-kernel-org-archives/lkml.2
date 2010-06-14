Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0FNIn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 04:43:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab0FNInx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 04:43:53 -0400
Date: Mon, 14 Jun 2010 10:43:32 +0200
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Jan Kara <jack@suse.cz>,
       Marius Tolzmann <tolzmann@molgen.mpg.de>,
       Miklos Szeredi <mszeredi@suse.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #15909] open("a/",O_NOFOLLOW) fails with ELOOP if "a" is
 a symbolic link to a directory.
Message-ID: <20100614084331.GB3903@quack.suse.cz>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
 <YPGdyfWGvNK.A.KL.C7OFMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPGdyfWGvNK.A.KL.C7OFMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 13-06-10 16:48:58, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15909
> Subject		: open("a/",O_NOFOLLOW) fails with ELOOP if "a" is a symbolic link to a directory.
> Submitter	: Marius Tolzmann <tolzmann@molgen.mpg.de>
> Date		: 2010-05-05 13:01 (40 days old)
> Handled-By	: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 		  Jan Kara <jack@suse.cz>
> Patch		: https://patchwork.kernel.org/patch/99291/
  The fix went in shortly before 2.6.34 was released (commit
002baeecf53677d2034113e34197ec221f42e037). So everything should be fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
