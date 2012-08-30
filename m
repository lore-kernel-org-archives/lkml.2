Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2H3M7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 08:59:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2H3M7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 08:59:14 -0400
Date: Thu, 30 Aug 2012 14:59:12 +0200
From: Michal Marek <mmarek@suse.cz>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC] kconfig/mconf.c: revision of curses initialization.
Message-ID: <20120830125912.GA14031@sepie.suse.cz>
References: <gi628woxo0.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi628woxo0.fsf@mx10.gouders.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 05:19:43PM +0200, Dirk Gouders wrote:
> Hello,
> 
> I noticed that in mconf, initscr() is called twice -- as far as I found
> out since commit d0e1e09568.
> 
> In case you see a need to fix that:
> 
> I first thought about simply removing the call in init_dialog() in
> util.c but then had the feeling that saving of initial cursor positions
> also perhaps is better done in that function...
> 
> Dirk
> 
> ------------------------------------------------------------------------
> From 1a4022eedbee6032dea16f67bbe4028a8d3d07a0 Mon Sep 17 00:00:00 2001
> From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Date: Mon, 6 Aug 2012 16:48:23 +0200
> Subject: [PATCH] kconfig/mconf.c: revision of curses initialization.
> 
> Since commit d0e1e09568 initscr() is called twice in mconf.
> 
> Do it only in init_dialog() in util.c and there also save the
> cursor position for the signal handler in mconf.c.
> 
> Signed-off-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>

Applied to kbuild.git#kconfig, thanks.

Michal
