Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162270Ab1FAI5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:57:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:46537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162202Ab1FAI5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:57:50 -0400
Date: Wed, 1 Jun 2011 17:58:43 +0900
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [039/146] [PARISC] wire up the fhandle syscalls
Message-ID: <20110601085843.GB12801@suse.de>
References: <20110601080303.433532961@blue.kroah.org>
 <1306917921.22348.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306917921.22348.7.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 09:45:21AM +0100, Ben Hutchings wrote:
> On Wed, 2011-06-01 at 16:59 +0900, Greg KH wrote:
> > 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> 
> These syscalls were added in 2.6.39!

Thanks for letting me know, I'll drop this, and the other parisc syscall
patch, from the .38-stable tree.

greg k-h
