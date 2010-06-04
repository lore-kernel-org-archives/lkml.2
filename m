Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0FDIg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:36:56 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:52788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab0FDIgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:36:54 -0400
Subject: Re: [PATCH] p54spi: replace internal "cx3110x" name with "p54spi"
From: Johannes Berg <johannes@sipsolutions.net>
To: Luke-Jr <luke@dashjr.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <201006021406.15393.luke@dashjr.org>
References: <201006012117.00432.luke@dashjr.org>
	 <1275465299.3915.0.camel@jlt3.sipsolutions.net>
	 <201006021406.15393.luke@dashjr.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 10:36:47 +0200
Message-ID: <1275640607.9953.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 14:06 -0500, Luke-Jr wrote:

> > >  	.driver = {
> > > -		/* use cx3110x name because board-n800.c uses that for the
> > > -		 * SPI port */
> > > -		.name		= "cx3110x",
> > > +		.name		= "p54spi",
> > >  		.bus		= &spi_bus_type,
> > 
> > maybe that comment wasn't clear enough ... it needs to be that way to be
> > properly linked up against SPI.
> 
> I don't understand what you mean here. Does the hardware-side of SPI use 
> string identifiers? These are the only two instances of "cx3110x" in the 
> kernel source; N8x0 board files expect "p54spi"

Hm, ok, I thought that the board stuff needed cx3110x. Hopefully it
doesn't differ in n810s?

johannes

