Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1CNMKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:10:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360Ab1CNMKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:10:51 -0400
Date: Mon, 14 Mar 2011 13:10:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr
Subject: Re: [PATCH 2/2] hid-ntrig: init settle and mode check
In-Reply-To: <20110311015238.GA11505@barra.bne.redhat.com>
Message-ID: <alpine.LNX.2.00.1103141310380.19969@pobox.suse.cz>
References: <1299731632-9814-1-git-send-email-rafi@seas.upenn.edu> <1299731632-9814-2-git-send-email-rafi@seas.upenn.edu> <20110311015238.GA11505@barra.bne.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Peter Hutterer wrote:

> > Adding a wait before the wakeup signal.
> > 
> > As a precautionary measure sanity check the current sensor mode.  If
> > needed reset it to "dual".
> > 
> > Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> > 
> > When the device is responding poorly and needs the wakeup call, it was
> > missing it.  Giving it a chance to settle first improves the chances
> > that signal gets through.
> > 
> > I was also seeing the device come up in strange modes where it did not
> > respond to physical stimulus.  Hopefully the quirk will fix that, but
> > even so it seems like a good idea to check.  It also makes me curious
> > what the "off" code is.
> > ---
> >  drivers/hid/hid-ntrig.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
> >  1 files changed, 43 insertions(+), 2 deletions(-)
> 
> no negative effects
> 
> Tested-by: Peter Hutterer <peter.hutterer@who-t.net>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
