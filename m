Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab1E3SWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:22:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36013 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1E3SWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:22:20 -0400
Date: Mon, 30 May 2011 20:22:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Valdis.Kletnieks@vt.edu
Cc: Rohit Yadav <rohityadav89@gmail.com>, len.brown@intel.com, trenn@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Arch: x86: process: Fix a compilation warning.
Message-ID: <20110530182221.GA16214@gere.osrc.amd.com>
References: <rohityadav89@gmail.com>
 <1306776629-13404-1-git-send-email-rohityadav89@gmail.com>
 <11791.1306777203@turing-police.cc.vt.edu>
 <BANLkTim2yJkQG=2JzFwxcAUfB3HF_m52Rg@mail.gmail.com>
 <13206.1306779099@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13206.1306779099@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 02:11:39PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 30 May 2011 23:28:47 +0530, Rohit Yadav said:
> 
> > Attached: New patch.
> 
> Still needs help:
> 
> > Remove unknown escape sequence \i in idle_setup.
> 
> > -		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
> > +		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012.\n");
> 
> Changelog should say "Fix mismatched escaped quotes to resolve compiler warning" or
> similar. You should explain *what* the patch does (fix the quotes) and *why*
> (because it's broken and won't compile).

Yep, all valid points. Another one would be to search whether this got
already fixed before wasting effort:

http://git.kernel.org/tip/598e887d8b01655780c81cc86a9e7820ed091580

But it's not like there's nothing else that needs fixing in Linux. I'd
suggest using the new 'make W=' (do 'make help' for more info) build
option to build single objects and have gcc do more extensive checks.
Some of them actually are valid and need fixing.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
