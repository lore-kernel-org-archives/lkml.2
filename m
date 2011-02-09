Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1BID01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:26:27 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37945 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab1BID00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:26:26 -0500
Date: Tue, 8 Feb 2011 21:26:21 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        mtk.manpages@gmail.com, Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v2 2/2] man-pages: SYSLOG_ACTION_* constants are now
 exported
Message-ID: <20110209032621.GA28107@localhost>
References: <1297203340.1748.15.camel@t41.thuisdomein>
 <20110208223251.GP1457@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208223251.GP1457@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> On Tue, Feb 08, 2011 at 11:15:34PM +0100, Paul Bolle wrote:
> > The kernel now exports <linux/syslog.h>. This makes the SYSLOG_ACTION_*
> > constants available to userspace. This allows to replace the magic
> > numbers used in this man page with (what should be) more descriptive
> > names. The quote form kernel/printk.c can now also be dropped.
> > 
> > A few (more or less related) things were also fixed or changed:
> > - add a new sub section "The command types";
> > - the (userspace) buffer is called bufp everywhere (and not buf);
> > - add some whitespace to all call descriptions;
> > - use "ignored" in some call descriptions (instead of "dummy").
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Acked-by: Kees Cook <kees.cook@canonical.com>
> 
> 
> As an aside, it might be a good idea to send an additional patch (since
> it's logically separate from this) to update this portion of the man-page:
> 
>    EPERM  An attempt was made to change console_loglevel or clear the
>           kernel message ring buffer by a process without  sufficient
>           privi lege (more precisely: without the CAP_SYS_ADMIN capability).
> 
> At least s/CAP_SYS_ADMIN/CAP_SYSLOG/, but probably include details about
> which options are considered privileged.
> 
> Though that should probably go with including the description of CAP_SYSLOG
> in the "capabilities" man-page.

Thanks for the reminder, Kees.  Michael, I'll try to get an update for
capabilities.7 to you soon.

-serge
