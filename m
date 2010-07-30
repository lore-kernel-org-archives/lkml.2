Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0G3Ouf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:50:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758692Ab0G3Oua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:50:30 -0400
Date: Fri, 30 Jul 2010 10:53:31 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100730145330.GL20261@redhat.com>
References: <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org> <4C5148A5.10809@suse.cz> <20100729144748.GI6249@redhat.com> <4C519899.9020206@suse.cz> <20100729151650.GA20261@redhat.com> <20100729193454.GC7877@merkur.ravnborg.org> <20100729195052.GB20261@redhat.com> <20100729230419.GA9357@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729230419.GA9357@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 01:04:19AM +0200, Sam Ravnborg wrote:
> First off let me correct myself.
> nonint_oldconfig does the following:
> - print any new options to stderr
> - if tere are any new options exit with exit code 2
> - it does _not_ touch the current configuration (as I wrongly implied above)
it does touch the current configuration if there aren't new options
but whatever

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

