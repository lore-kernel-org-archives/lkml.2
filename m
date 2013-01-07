Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3AGRo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:44:58 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:51699 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3AGRo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:44:57 -0500
Date: Mon, 7 Jan 2013 09:44:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Nickolai Zeldovich <nickolai@csail.mit.edu>,
        William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>, linux-kernel@vger.kernel.org,
        speakup@braille.uwo.ca
Subject: Re: [PATCH] drivers/staging/speakup: avoid out-of-range access
Message-ID: <20130107174453.GA15120@kroah.com>
References: <1357413465-42357-1-git-send-email-nickolai@csail.mit.edu>
 <20130105192944.GL5965@type.youpi.perso.aquilenet.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130105192944.GL5965@type.youpi.perso.aquilenet.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 08:29:44PM +0100, Samuel Thibault wrote:
> Indeed. The same happens in synth_add, so Greg please use this instead:
> 
> 
> Check that array index is in-bounds before accessing the synths[] array.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Wait, Nickolai wrote the first patch, so how could he sign off on your
patch?  How about sending me an add-on patch on top of the first one
which adds the additional check?  That way I'll apply both of them and
everyone will get the proper credit?

thanks,

greg k-h
