Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab0FBTIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:08:46 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:39637 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab0FBTIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:08:44 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54spi: replace internal "cx3110x" name with "p54spi"
Date: Wed, 2 Jun 2010 14:06:05 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo; KDE/4.3.5; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <201006012117.00432.luke@dashjr.org> <1275465299.3915.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275465299.3915.0.camel@jlt3.sipsolutions.net>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006021406.15393.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 June 2010 02:54:59 am Johannes Berg wrote:
> On Tue, 2010-06-01 at 21:16 -0500, Luke-Jr wrote:
> >  static struct spi_driver p54spi_driver = {
> >  	.driver = {
> > -		/* use cx3110x name because board-n800.c uses that for the
> > -		 * SPI port */
> > -		.name		= "cx3110x",
> > +		.name		= "p54spi",
> >  		.bus		= &spi_bus_type,
> 
> maybe that comment wasn't clear enough ... it needs to be that way to be
> properly linked up against SPI.

I don't understand what you mean here. Does the hardware-side of SPI use 
string identifiers? These are the only two instances of "cx3110x" in the 
kernel source; N8x0 board files expect "p54spi"
