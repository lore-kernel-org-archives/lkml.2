Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2LJSNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:13:47 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47865 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2LJSNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:13:44 -0500
Date: Mon, 10 Dec 2012 10:13:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Kamal Mostafa <kamal@canonical.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dudley Du <dudl@cypress.com>,
        David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH v6] Cypress PS/2 Trackpad driver
Message-ID: <20121210181338.GA11233@core.coreip.homeip.net>
References: <1354846216-19707-1-git-send-email-kamal@canonical.com>
 <20121208125405.GA3183@polaris.bitmath.org>
 <1354986225.2795.107.camel@fourier>
 <20121210171359.GA881@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210171359.GA881@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 06:13:59PM +0100, Henrik Rydberg wrote:
> > > > +config MOUSE_PS2_CYPRESS
> > > > +       bool "Cypress PS/2 mouse protocol extension" if EXPERT
> > > 
> > > Why EXPERT here?
> > > 
> > > > +       default y
> > > 
> > > Should it really be default y here?
> > 
> > 
> > This config entry (with phrases "if EXPERT" and "default y") was simply
> > cloned from similar devices (e.g. SYNAPTICS, ALPS, LIFEBOOK).
> > 
> > If your preference is that CYPRESS should be disabled by default, I'll
> > omit those phrases.  Please advise.
> 
> Dmitry, which default do you prefer here?

Given that psmouse is monolithic and can't be [easily] split into
separate drivers (because they each protocol has to be actively probed),
I believe that allprotocols should be enabled by default. People who
really know what they are doing can reduce the size by compiling parts
of it out.

So copying what other protocols did was right ;)

Thanks.

-- 
Dmitry
