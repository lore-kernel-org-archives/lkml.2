Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2GRSRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:17:21 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39796 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab2GRSRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:17:16 -0400
Date: Wed, 18 Jul 2012 14:17:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: linux-next: Trees and MAINTAINERS of random drivers?
Message-ID: <20120718181709.GC22107@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-next <linux-next@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
References: <CA+icZUVPS=xkm0+=6JZPGmT9BRJgbGav3AHCgpYuvt-71+xhmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVPS=xkm0+=6JZPGmT9BRJgbGav3AHCgpYuvt-71+xhmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 01:09:04PM +0200, Sedat Dilek wrote:
> [3] lists Ted as new random driver maintainer, but in [4] I found Matt
> as maintainer:
> 
> 5656 RANDOM NUMBER DRIVER
> 5657 M:      Matt Mackall <mpm@selenic.com>
> 5658 S:      Maintained
> 5659 F:      drivers/char/random.c
> 
> I do not think that this is still correct and furthermore in Ted's
> random.git#dev tree I see commits changing "drivers/char/random.c"
> file.
> So, that above block should IMHO be dropped and "F:
> drivers/char/random.c" added to [6]?

Oh, I see, I screwed up my update to the MAINTAINERS file and updated
the wrong block.  I'll fix it....

					- Ted
