Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab1D1Uvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:51:31 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52530 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932611Ab1D1Uv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:51:29 -0400
Date: Thu, 28 Apr 2011 22:51:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
Subject: Re: End of FAT directories
Message-ID: <20110428205128.GA23082@elf.ucw.cz>
References: <1303498136.8485.128.camel@localhost>
 <87hb9qnho4.fsf@devron.myhome.or.jp>
 <1303509408.8485.146.camel@localhost>
 <87bozxomqd.fsf@devron.myhome.or.jp>
 <1303558711.8485.166.camel@localhost>
 <20110428132551.GA5701@ucw.cz>
 <1303998185.8188.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303998185.8188.18.camel@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Kernel should stop at zero invalid entry.
> > 
> > fsck should consider any garbage past zero entry as an error, and zero
> > it out. (Complaining about duplicate blocks is unhelpful but better
> > than nothing.  It should really zero the garbage out.)
> 
> In fact, what you describe is something I would call "consistent". I was
> not implying that kernel and dosfsck should do exactly the same thing,
> but I was implying that the kernel and dosfsck should either both or

Aha, violent agreement, then. Good :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
