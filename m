Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2DHUXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 16:23:15 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:60229 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2DHUXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 16:23:14 -0400
Date: Sun, 8 Apr 2012 16:23:10 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
Message-ID: <20120408202310.GA17765@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
 <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
 <CAB=NE6Xt3yeCvW-t7mbEWoYr04Rg1uvObAMTatAdpHtgsdZvYA@mail.gmail.com>
 <20120407024941.GB11295@thunk.org>
 <CAB=NE6Wn4w_rmm-9dTjeLCmFBwFUv_R+o05=UW1SODBN2hFH0w@mail.gmail.com>
 <20120407211512.GC11295@thunk.org>
 <CAB=NE6UJsnMx=p3Rr+iCVjgMk3YgxQiyXf_CbF0UKh93FrBezg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6UJsnMx=p3Rr+iCVjgMk3YgxQiyXf_CbF0UKh93FrBezg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2012 at 05:52:53PM -0700, Luis R. Rodriguez wrote:
> > If you are really worried about people being upset that currently, you
> > have to explicitly add a GPL license to BSD-licensed driver code
> > before it gets imported into the kernel, and you are trying to
> > sidestep the issue by adding a "GPL-Compatible" license (on the
> > grounds that a BSD-only license qualifies as GPl-Compatible), let's
> > have that debate openly, instead of trying to side-step it by adding
> > "GPL-compatible" to include/linux/license.h and allowing BSD-only
> > modules to use GPL-only symbols via a back door.
> 
> I think you are implying that I want BSD licensed modules to use
> GPL-only symbols. That is not the case. There are two things to
> consider here and I think its best to separate them -- runtime and
> stand alone file licenses.

No, I wasn't thinking that; this is why I was asking what your motives
were.  I had *assumed* there were BSD'ites which were squicked out by
even having the three letters "GPL" in the file in any shape or form,
and so they wanted to keep a file licensed solely under a BSD-only
(w/o the advertising clause), even if the driver was primarily being
updated and maintained within the Linux kernel sources.

I didn't pick up from your other e-mail that you were just going to
use a MODULE_LICENSE of "GPL" which is just as good assuming the folks
from BSD who wanted to share drivers were OK with it.

						- Ted
