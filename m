Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab1BPMRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:17:44 -0500
Received: from smtp.nokia.com ([147.243.128.26]:21961 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab1BPMRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:17:42 -0500
Date: Wed, 16 Feb 2011 13:57:29 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Linus Walleij <linus.walleij@linaro.org>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        ext Tony Lindgren <tony@atomide.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Peter De-Schrijver <Peter.De-Schrijver@nokia.com>,
        santosh.shilimkar@ti.com, Ambresh <a0393775@ti.com>,
        felipe.balbi@nokia.com, Jouni Hogander <jouni.hogander@nokia.com>,
        Paul Mundt <lethal@linux-sh.org>, Lee Jones <Lee.Jones@linaro.org>,
        maxime.coquelin-nonst@stericsson.com,
        Jonas =?utf-8?B?77+9YmVyZw==?= <jonas.aberg@stericsson.com>,
        ext Nishanth Menon <nm@ti.com>
Subject: Re: [PATCHv5 0/3] Introduce the /proc/socinfo and use it to export
 OMAP data
Message-ID: <20110216115729.GA29817@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1273587331-24604-1-git-send-email-eduardo.valentin@nokia.com>
 <AANLkTin7vRMreG3hOAk95MYZUCV-Kr6ac7gD7jgvX6Gf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin7vRMreG3hOAk95MYZUCV-Kr6ac7gD7jgvX6Gf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Tue, Feb 15, 2011 at 01:58:00PM +0100, ext Linus Walleij wrote:
> 2010/5/11 Eduardo Valentin <eduardo.valentin@nokia.com>:
> 
> > Here is the version 5 of the change to export OMAP data to userspace
> > (name, revision, id code, production id and die id).
> >
> > Basically, this version is still attempting to create a new file under /proc.
> > It is the /proc/socinfo, which should be used to export bits which are SoC specific
> > (not CPU related, nor machine related).
> >
> > So, differences between previous version are:
> > - merged patch 02/04 with 03/04 to avoid compilation breakages.
> > - simplified the seq_file usage by using the single_open and single_release functions
> > - exported a function to register a seq_operation .show callback
> > - adapted the changes accordingly
> >
> > As usual, comments are welcome.
> 
> Eduardo, what has happened to this patchset?

Got forgotten :-(. Unfortunately I didn't pushed it hard enough.

> 
> Now we need something similar for arch/arm/mach-ux500 and I was sort of
> hoping that this infrastructure would be in place already... wrong I was.

Right.

> 
> Do you want help in picking it up and try to polish it up?

Yeah, but it would need a refactoring. IIRC, result of last discussion was that
we should not mess with /proc. So, maybe moving back to something under sysfs.
Perhaps /sys/devices/soc or so?

> 
> Yours,
> Linus Walleij

-- 
Eduardo Valentin
