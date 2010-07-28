Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab0G1SzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:55:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36602 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0G1SzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:55:06 -0400
Date: Wed, 28 Jul 2010 20:55:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: trapdoor6@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, trivial@kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: Small typo in kernel [current source from git] .config option
Message-ID: <20100728185505.GF29266@merkur.ravnborg.org>
References: <AANLkTi=ON+60QM9Ooepwr7FLr+RV1TN6X-6D78tuNfCS@mail.gmail.com> <20100727165549.GC26649@merkur.ravnborg.org> <AANLkTimmLLJ9VrbD94GA3ZH2XvBwEAAcrrL_etWAoEea@mail.gmail.com> <4C500E41.40708@suse.cz> <AANLkTi=rPP7OfoNoyVkM0XR08ns6p0+cENzcdk7gY8TE@mail.gmail.com> <4C504FBB.3020600@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C504FBB.3020600@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 05:41:47PM +0200, Michal Marek wrote:
> (adding Nir, who wrote nconfig, to CC).
> 
> On 28.7.2010 14:17, trapDoor wrote:
> > On Wed, Jul 28, 2010 at 12:02 PM, Michal Marek <mmarek@suse.cz> wrote:
> >> respectively). Unfortunatelly, there doesn't seem to be a way to
> >> highlight single letters in an ncurses menu, hence the strange
> >> cApitalization :(.
> > 
> > I wonder how is this resolved in other console applications such as
> > Midnight Commander. Does it have its own implementation for
> > highlighting characters (it uses coloured mnemonics e.g. in menus) or
> > it's based on some common Linux/Unix library which perhaps could be
> > used for the nconfig as well?
> 
> The problem is that nconfig uses the higher-level ncurses libraries
> libmenu and libpanel, which make some things easier, but aren't as
> flexible as using ncurses directly. Patches are welcome of course :-).

The capitilazing is the main reason why I have
not recommended nconfig to be default.

And I doubt the shortcut letters are used that often.
One idea could be to drop the shortcut for the individual menus.

	Sam
