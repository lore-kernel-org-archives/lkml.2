Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3ABCEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 21:04:25 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54729 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab3ABCEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 21:04:24 -0500
Date: Tue, 1 Jan 2013 18:04:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,staging/speakup] Prefix externally-visible symbols
Message-ID: <20130102020426.GA26315@kroah.com>
References: <20130101225257.GC6582@type.youpi.perso.aquilenet.fr>
 <20130102011722.GA25903@kroah.com>
 <20130102013818.GI6582@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130102013818.GI6582@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 02:38:18AM +0100, Samuel Thibault wrote:
> Greg Kroah-Hartman, le Tue 01 Jan 2013 17:17:22 -0800, a écrit :
> > On Tue, Jan 01, 2013 at 11:52:57PM +0100, Samuel Thibault wrote:
> > > This prefixes all externally-visible symbols of speakup with "spk_".
> > > (or makes static some of them which do not actually need to be
> > > externally-visible)
> > 
> > Care to break this up into smaller pieces?  Like one for the variables
> > that should just be static?  And then the other bits?
> 
> Done so.

Thanks, I'll queue them up when I get back from vacation next week.

greg k-h
