Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1AGWaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:30:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:38788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab1AGWaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:30:04 -0500
Date: Fri, 7 Jan 2011 23:30:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "James T. Dickson" <james.dickson@jtdata.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce 'notimeout' blacklist for Dell Vostro
 V13 (was Re: Synaptics touchpad on Dell Vostro V13)
In-Reply-To: <20110107172847.GA28785@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1101072329170.26685@pobox.suse.cz>
References: <8583070.26.1294325869588.JavaMail.root@butch.jtdata.net> <alpine.LNX.2.00.1101071105350.26685@pobox.suse.cz> <20110107172847.GA28785@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Dmitry Torokhov wrote:

> > > Placing it in /etc/pm/sleeps.d/ .
> > > 
> > > #!/bin/sh
> > > #
> > > # Reload the AT keyboard interface.
> > > 
> > > case "$1" in
> > >         hibernate|suspend)
> > >                 rmmod psmouse
> > >                 ;;
> > >         thaw|resume)
> > >                 modprobe psmouse
> > >                 ;;
> > >         *)
> > >                 ;;
> > > esac
> > 
> > I have already came across reports of this being needed for synaptics 
> > touchpads on several different machines already, so this seems to be 
> > rather unrelated problem to me.
> 
> Right, but it would be nice if we could find the problem...

Definitely, working on this is with the original reporter is on my TODO 
list (I don't know yet whether that particular machine is affected or 
not). Will keep you updated.

> > Dmitry, what is your current plan with the notimeout thing for V13, 
> > please? Still .38 material?
> 
> Yeah, especially given that not all V13 seem to suffer from
> suspend/resume issue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
