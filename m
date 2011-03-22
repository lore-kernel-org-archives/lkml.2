Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1CVW1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:27:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab1CVW1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:27:12 -0400
Date: Tue, 22 Mar 2011 15:25:48 -0700
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Antony Pavlov <antony@niisi.msk.ru>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Guillaume LECERF <glecerf@gmail.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [02/44] mtd: jedec_probe: Change variable name
 from cfi_p to cfi
Message-ID: <20110322222548.GB26834@suse.de>
References: <20110321231050.942106776@clark.kroah.org>
 <1300759133.26693.354.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300759133.26693.354.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 01:58:53AM +0000, Ben Hutchings wrote:
> On Mon, 2011-03-21 at 16:09 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Antony Pavlov <antony@niisi.msk.ru>
> > 
> > commit efba2e313ea1b1bd69a7c4659263becf43bb1adc upstream.
> > 
> > In the following commit, we'll need to use the CMD() macro in order to
> > fix the initialisation of the sector_erase_cmd field. That requires the
> > local variable to be called 'cfi', so change it first in a simple patch.
> [...]
> 
> The following change in this series is 'mtd: add "platform:" prefix for
> platform modalias', which surely doesn't depend on this one.
> 
> So it looks like the commit this was preparing for has been dropped
> somewhere along the way to stable.

Thanks, the other patches went into .37 and .38, not .32, so I've
dropped this one.

thanks,

greg k-h
