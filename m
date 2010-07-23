Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab0GWNTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:19:06 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41977 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759536Ab0GWNTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:19:01 -0400
Date: Fri, 23 Jul 2010 06:18:25 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Wilson <"email addresshidden"@ogre.sisk.pl>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
Message-ID: <20100723131825.GT3948@outflux.net>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
 <tneGvaw1wLL.A.9fB.v3XSMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tneGvaw1wLL.A.9fB.v3XSMB@chimera>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Fri, Jul 23, 2010 at 01:47:30PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).

The regression still exists[1] in the mainline kernel -- the confirmed fix
mentioned below has not been committed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
> Subject		: [Q35 bisected] hang at init of i915 driver
> Submitter	: Kees Cook <kees@outflux.net>
> Date		: 2010-06-25 18:20 (29 days old)
> First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad
> Handled-By	: Tim Gardner <tim.gardner@canonical.com>
> Patch		: https://patchwork.kernel.org/patch/111130/

Thanks,

-Kees

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=drivers/char/agp/intel-gtt.c;h=HEAD

-- 
Kees Cook
Ubuntu Security Team
