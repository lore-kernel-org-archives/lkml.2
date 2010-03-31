Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0CaDuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:50:25 -0400
Received: from ozlabs.org ([203.10.76.45]:53348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0CaDuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:50:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Wed, 31 Mar 2010 14:20:21 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200911222201.59471.linux@rainbow-software.org> <200912212054.18055.rusty@rustcorp.com.au> <201003221444.39241.linux@rainbow-software.org>
In-Reply-To: <201003221444.39241.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003311420.21371.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Mar 2010 12:14:38 am Ondrej Zary wrote:
> On Monday 21 December 2009, Rusty Russell wrote:
> > On Sat, 19 Dec 2009 06:22:39 am Ondrej Zary wrote:
> > > Generate pnp:d aliases for isapnp_device_tables. This allows udev to load
> > > these modules automatically.
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > I'm happy with this, so I've separated and taken them.  Too late for the
> > merge window I'm afraid, but it'll be in next one.
> 
> When will this go in?

Sorry, my bad.  It was at the back of my queue and got lost.

It'd be nice for it to go in, but it needs at least a few days in linux-next,
simple as it is.  Linus is unlikely to believe me if I tell him it's suddenly
urgent.

Sorry,
Rusty.



> 
> 
