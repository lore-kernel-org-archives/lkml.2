Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0FIPw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:52:58 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62658 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab0FIPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:52:55 -0400
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: tytso@mit.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
       Chris Mason <chris.mason@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       David Woodhouse <dwmw2@infradead.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>
In-Reply-To: <20100609154448.GC6162@thunk.org>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
	 <20100528132318.0783675a.akpm@linux-foundation.org>
	 <20100528211432.GM31073@ZenIV.linux.org.uk>
	 <20100528141755.42958d81.akpm@linux-foundation.org>
	 <20100609154448.GC6162@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 18:49:15 +0300
Message-ID: <1276098555.5677.131.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jun 2010 15:51:31.0224 (UTC) FILETIME=[A121B180:01CB07EB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 11:44 -0400, tytso@mit.edu wrote:
> On Fri, May 28, 2010 at 02:17:55PM -0700, Andrew Morton wrote:
> > > 
> > > The real issue is that it's almost certainly an overdesign.  Let's
> > > get rid of the bogus uses first and figure out what's happening in
> > > what remains, OK?
> > 
> > That would be good.
> 
> Can we figure out what the new names will be for these accessor
> functions, and then pursuade Linus to be willing to add patch #1 in
> this series to add these accessor functions (without any users for
> these functions, that would wait until the next merge window) to
> 2.6.35-rc3 or -rc4, please?
> 
> It will make life much easier for fs maintainers to merge the patches,
> especially if they've done some cleanup to reduce the bogus places
> where s_dirt was getting set in the first place.  That way I can apply
> my patch to reduce the use of s_dirt[1], then apply a patch I carry in
> my own tree to convert to the new accessor functions without worrying
> about patch conflicts.

Yes, that would be nice, Al?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

