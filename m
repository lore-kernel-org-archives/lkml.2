Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab1CXRra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:47:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63172 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab1CXRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:47:28 -0400
Date: Thu, 24 Mar 2011 17:47:23 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Subject: Re: [RFC PATCHv2 0/4] Support for OTP memory
Message-ID: <20110324174722.GH3130@pulham.picochip.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <AANLkTim3kMCE=LhCRcUDif8ENSA-E-_Xga5cDSYs0x25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim3kMCE=LhCRcUDif8ENSA-E-_Xga5cDSYs0x25@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Mar 24, 2011 at 01:39:56PM -0400, Mike Frysinger wrote:
> On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> > Following some feedback from Greg, I've updated this series to be more
> > of a generic OTP layer.  Everything is now registered under the "otp"
> > bus and I've also converted the blackfin OTP driver to use this
> > framework (which is the only current OTP driver I could find).
> 
> really, i'm the only one who wrote a driver ?  that's boring.

Yes, and I'm quite surprised at that.  Perhaps I've missed some.

> i guess this isnt trying to handle OTP stuff that exists in the MTD
> layer already ?

No, I believe that the OTP stuff in the MTD layer is where some flash 
chips have a small section that can be write protected so it's more like 
a permanent write disable to that sector whereas the thing I'm looking 
at is on a per-bit basis.

I did have a look at if there was some kind of way to fit this stuff 
into the MTD layer but it felt like it was really shoehorning it in.

> > Mike, I wasn't 100% sure how big the blackfin OTP is but I found a
> > datasheet talking about 64KB so I've assumed that for now.
> 
> the datasheets say 64K *bits* :).  i think all our datasheets tend to
> use bits rather than bytes because they're stupid and bigger numbers
> always means better parts !

That sounds very familiar!

Jamie
