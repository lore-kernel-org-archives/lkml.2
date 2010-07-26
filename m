Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0GZVsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:48:39 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:56734 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0GZVsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:48:37 -0400
Date: Mon, 26 Jul 2010 23:48:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3/3] kbuild: allow user to assign LDFLAGS_MODULE
Message-ID: <20100726214836.GA22433@merkur.ravnborg.org>
References: <20100726203814.GA18828@merkur.ravnborg.org> <20100726204432.GC18853@merkur.ravnborg.org> <AANLkTimrZwE+_awxxoQtdkeS7OVY+jDMawyfkYUas58G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimrZwE+_awxxoQtdkeS7OVY+jDMawyfkYUas58G@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 04:54:05PM -0400, Mike Frysinger wrote:
> On Mon, Jul 26, 2010 at 16:44, Sam Ravnborg wrote:
> > From ce765a28adeb8878413a49ce62f442022d6a5b6a Mon Sep 17 00:00:00 2001
> > From: Sam Ravnborg <sam@ravnborg.org>
> > Date: Mon, 26 Jul 2010 22:20:12 +0200
> > Subject: [PATCH 3/3] kbuild: allow user to assign LDFLAGS_MODULE
> >
> > Do not use LDFLAGS_MODULE in the top-level Makefile.
> > So if user assign a value to LDFALGS_MODULE the
> > original value is not lost.
> >
> > Use a kbuild internal variable that archs can use,
> > and update all archs that used LDFALGS_MODULE.
> 
> assuming end behavior is the same, the Blackfin part is:
> Acked-by: Mike Frysinger <vapier@gentoo.org>

It is :-)

> 
> also, could you say the same thing for CFLAGS_MODULE ?

Good point. Need to do the same here.
I also realised I need to update Documentation/kbuild/makefiles.txt

Michal - I will send an updated serie tomorrow.

	Sam
