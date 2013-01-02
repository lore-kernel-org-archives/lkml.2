Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3ABBRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 20:17:23 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42679 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3ABBRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 20:17:21 -0500
Date: Tue, 1 Jan 2013 17:17:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,staging/speakup] Prefix externally-visible symbols
Message-ID: <20130102011722.GA25903@kroah.com>
References: <20130101225257.GC6582@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130101225257.GC6582@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2013 at 11:52:57PM +0100, Samuel Thibault wrote:
> This prefixes all externally-visible symbols of speakup with "spk_".
> (or makes static some of them which do not actually need to be
> externally-visible)

Care to break this up into smaller pieces?  Like one for the variables
that should just be static?  And then the other bits?

Also, I think you just changed user-visable variables/sysfs files, which
isn't acceptable.  Be careful about that when you resend.

thanks,

greg k-h
