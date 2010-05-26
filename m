Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0EZO5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:57:06 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:40906 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290Ab0EZO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:57:04 -0400
Date: Wed, 26 May 2010 16:57:00 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Jon Hunter <jon-hunter@ti.com>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] transitional config CONFIG_GENERIC_CLOCKEVENTS
Message-ID: <20100526145700.GA5475@faui48a.informatik.uni-erlangen.de>
References: <20100526134415.GD7508@faui49.informatik.uni-erlangen.de> <alpine.LFD.2.00.1005261554280.2995@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005261554280.2995@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:56:09PM +0200, Thomas Gleixner wrote:
> On Wed, 26 May 2010, Christoph Egger wrote:
> 
> > Hi all!
> > 
> > 	As part of the VAMOS[0] research project at the University of
> > Erlangen we are looking at multiple integrity errors in linux'
> > configuration system.
> > 
> > 	This was an aid for a transition finished 2007 so not
> > necessary for some time now, ready for removal.
> > 
> > 	Please keep me informed of this patch getting confirmed /
> > merged so we can keep track of it.
> 
> It's still necessary/helpful for any arch which is not yet
> converted. And there are a few unfortunately.

	Are you referring to some out-of-tree architectures? I've
verified the string GENERIC_CLOCKEVENTS_MIGR is only appearing at this
single spot in kconfig and nowhere else in code/Kconfig in my
up-to-date linux tree.

	If not maybe I was a bit unclear about the actual rational
behind the code patch. As GENERIC_CLOCKEVENTS_MIGR is not selectable
GENERIC_CLOCKEVENTS_BUILD implies GENERIC_CLOCKEVENTS so inside a
GENERIC_CLOCKEVENTS_BUILD block a check for GENERIC_CLOCKEVENTS is
non-necessary for everything inside the linus tree and the else branch
unavailable. In this case I'll prepare an more complete patch as
suggested by CHristoph Hellwig tomorrow or friday.

Regards

	Christoph
