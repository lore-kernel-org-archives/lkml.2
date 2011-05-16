Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab1EPSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 14:25:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab1EPSZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 14:25:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 8/9] OMAP1 / PM: Use generic clock manipulation routines for runtime PM
Date: Mon, 16 May 2011 20:26:26 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104242343.41456.rjw@sisk.pl> <87mxindk7m.fsf@ti.com>
In-Reply-To: <87mxindk7m.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105162026.27009.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 16, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Convert OMAP1 to using the new generic clock manipulation routines
> > and a device power domain for runtime PM instead of overriding the
> > platform bus type's runtime PM callbacks.  This allows us to simplify
> > OMAP1-specific code and to share some code with other platforms
> > (shmobile in particular).
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Acked-by: Kevin Hilman <khilman@ti.com>

Thanks!
