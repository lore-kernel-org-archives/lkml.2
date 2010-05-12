Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0ELRqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:46:54 -0400
Received: from kroah.org ([198.145.64.141]:45082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab0ELRqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:46:53 -0400
Date: Wed, 12 May 2010 10:46:11 -0700
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, "Arce, Abraham" <x0066660@ti.com>,
       "trivial@kernel.org" <trivial@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] EEPROM: Header file cleanup
Message-ID: <20100512174611.GB27912@kroah.com>
References: <27F9C60D11D683428E133F85D2BB4A53043DFD5808@dlee03.ent.ti.com>
 <20100512093015.GE13984@pengutronix.de>
 <20100512113814.642f6b10@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512113814.642f6b10@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 11:38:14AM +0200, Jean Delvare wrote:
> On Wed, 12 May 2010 11:30:15 +0200, Wolfram Sang wrote:
> > On Tue, May 11, 2010 at 01:08:15PM -0500, Arce, Abraham wrote:
> > > Change eeprom.c header file to format as in conventions
> > > 
> > > Signed-off-by: Abraham Arce <x0066660@ti.com>
> > > ---
> > >  drivers/misc/eeprom/eeprom.c |   40 ++++++++++++++++++++--------------------
> > >  1 files changed, 20 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
> > > index f939ebc..fffa2e8 100644
> > > --- a/drivers/misc/eeprom/eeprom.c
> > > +++ b/drivers/misc/eeprom/eeprom.c
> > > @@ -1,24 +1,24 @@
> > >  /*
> > > -    Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
> > > -			       Philip Edelbrock <phil@netroedge.com>
> > > -    Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
> > > -    Copyright (C) 2003 IBM Corp.
> > > -    Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
> > > -
> > > -    This program is free software; you can redistribute it and/or modify
> > > -    it under the terms of the GNU General Public License as published by
> > > -    the Free Software Foundation; either version 2 of the License, or
> > > -    (at your option) any later version.
> > > -
> > > -    This program is distributed in the hope that it will be useful,
> > > -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > -    GNU General Public License for more details.
> > > -
> > > -    You should have received a copy of the GNU General Public License
> > > -    along with this program; if not, write to the Free Software
> > > -    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > > -*/
> > > + * Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
> > > + *                           Philip Edelbrock <phil@netroedge.com>
> > > + * Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
> > > + * Copyright (C) 2003 IBM Corp.
> > > + * Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License as published by
> > > + * the Free Software Foundation; either version 2 of the License, or
> > > + * (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program; if not, write to the Free Software
> > > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > > + */
> > 
> > If you are touching this anyhow, could you also update the address of the FSF?
> > (or maybe remove the address block if the original authors are fine with it).
> 
> This would definitely be fine with me (even though I'm not the original
> author.)

Removing it would be fine, and better.

thanks,

greg k-h
