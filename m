Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0HAJ3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 05:29:04 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:46753 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab0HAJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 05:29:00 -0400
Date: Sun, 1 Aug 2010 11:28:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: nir.tzachar@gmail.com
Cc: mmarek@suse.cz, rdunlap@xenotime.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, trapdoor6@gmail.com,
        justinmattock@gmail.com
Subject: Re: [PATCH] nconfig: add search support
Message-ID: <20100801092859.GA12213@merkur.ravnborg.org>
References: <AANLkTik1p0oK=-msd0a-4wA88Z-Cv29qHVNUYeEETcJD@mail.gmail.com> <1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1280647233-2578-1-git-send-email-nir.tzachar@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 10:20:33AM +0300, nir.tzachar@gmail.com wrote:
> From: Nir Tzachar <nir.tzachar@gmail.com>
> 
> Remove the old hotkeys feature, and replace by a regular string search.
> >From nconfig help:
> 
> Pressing '/' triggers search mode. nconfig does regular string match, case
> insensitive, starting at the begining of each menu line.
> Pressing Enter highlights the next match, Backspace removes one character from
> the match string. Pressing either '/' again or ESC exits search mode.
> 
> Rebind the '/' key (which allowed to search for symbols) to F8
> 
> Signed-off-by: Nir Tzachar <nir.tzachar@gmail.com>

Got following warning when I build:
scripts/kconfig/nconf.c: In function ât_mext_matchâscripts/kconfig/nconf.c:512: warning: implicit declaration of function âblankâ

The searching works great! And good to see the capitilazation gone.

But it is ackward that I have to press ESC to leave searcing.

I can navigate up/down, but entering a menu should terminate search.
Also pressing enter (to select a symbol) should terminate search.

I also tried to do first search using "/", then search for a symbol using F8.
Again search was not terminated when I came back.

There is likely much more cases...

	Sam
