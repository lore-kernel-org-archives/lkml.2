Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2LOWYn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 17:24:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab2LOWYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 17:24:41 -0500
Date: Sat, 15 Dec 2012 17:24:32 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [GIT PULL] fbdev changes for 3.8
Message-ID: <20121215222431.GA7153@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-omap <linux-omap@vger.kernel.org>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <50CAFDFF.3070802@ti.com>
 <CA+55aFz9+3mOZcjJ9C-izKkidT9mxeO7xUubJER0OTjcZjE=2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz9+3mOZcjJ9C-izKkidT9mxeO7xUubJER0OTjcZjE=2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 01:11:04PM -0800, Linus Torvalds wrote:
 > On Fri, Dec 14, 2012 at 2:22 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
 > > Hi Linus,
 > >
 > > Florian, the fbdev maintainer, has been very busy lately, so I offered to send
 > > the pull request for fbdev for this merge window.
 > 
 > Pulled. However, with this I get the Kconfig question
 > 
 >    OMAP2+ Display Subsystem support (OMAP2_DSS) [N/m/y/?] (NEW)
 > 
 > which doesn't make a whole lot of sense on x86-64, unless there's
 > something about OMAP2 that I don't know.
 > 
 > So I'd suggest making that OMAP2_DSS be dependent on OMAP2. Or at
 > least ARM. Because showing it to anybody else seems insane.
 > 
 > Same goes for FB_OMAP2 for that matter. I realize that it's likely
 > nice to get compile testing for this on x86-64 too, but if that's the
 > intent, we need to think about it some more. I don't think it's good
 > to ask actual normal users questions like this just for compile
 > coverage.

This OMAP stuff has been creeping into x86 builds for a while.
Grep from my current build config ..

# CONFIG_OMAP_OCP2SCP is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_OMAP2_DSS is not set
# CONFIG_OMAP_USB2 is not set

There was some other arm-ism that does the same that I' currently forgetting,
or maybe that got fixed..

	Dave

