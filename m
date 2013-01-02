Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3ABBiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 20:38:22 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:36869 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3ABBiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 20:38:21 -0500
Date: Wed, 2 Jan 2013 02:38:18 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,staging/speakup] Prefix externally-visible symbols
Message-ID: <20130102013818.GI6582@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	William Hubbs <w.d.hubbs@gmail.com>,
	Chris Brannon <chris@the-brannons.com>,
	Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org
References: <20130101225257.GC6582@type.youpi.perso.aquilenet.fr>
 <20130102011722.GA25903@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130102011722.GA25903@kroah.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman, le Tue 01 Jan 2013 17:17:22 -0800, a écrit :
> On Tue, Jan 01, 2013 at 11:52:57PM +0100, Samuel Thibault wrote:
> > This prefixes all externally-visible symbols of speakup with "spk_".
> > (or makes static some of them which do not actually need to be
> > externally-visible)
> 
> Care to break this up into smaller pieces?  Like one for the variables
> that should just be static?  And then the other bits?

Done so.

> Also, I think you just changed user-visable variables/sysfs files, which
> isn't acceptable.  Be careful about that when you resend.

Oops, I thought these were variable references, but it's actually done
through callbacks indeed. Fixed.

Samuel
