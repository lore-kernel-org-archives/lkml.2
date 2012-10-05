Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2JEPaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:30:04 -0400
Received: from mail.x86-64.org ([217.9.48.20]:48385 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab2JEPaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:30:00 -0400
Date: Fri, 5 Oct 2012 17:29:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@amd64.org>, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Fix bogus "callbacks suppressed" messages
Message-ID: <20121005152948.GC24764@aftab.osrc.amd.com>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
 <20121004112347.GA245@x4>
 <20121004115157.GA245@x4>
 <20121004124025.GC21028@aftab.osrc.amd.com>
 <20121004131101.GA245@x4>
 <506EC1AE.6000201@suse.cz>
 <20121005122741.GB8019@aftab.osrc.amd.com>
 <20121005125717.GB245@x4>
 <20121005142639.GA20065@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121005142639.GA20065@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 07:26:39AM -0700, Greg Kroah-Hartman wrote:
> I don't have a problem with this patch, but I don't understand why
> it's now showing up. There haven't been any changes in the ratelimit.h
> area recently that I can see, so why is this change needed now? What
> is in the tty layer that is causing this, just the fact that it's
> actually being used now?

>From my quick semi-skilled git history browsing, I'd say it's
5d4121c04b357 which added the WARN_RATELIMIT to tty_init_dev during the
current merge window.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
