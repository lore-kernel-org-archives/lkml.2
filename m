Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab0HROld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:41:33 -0400
Received: from kroah.org ([198.145.64.141]:40537 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab0HROlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:41:31 -0400
Date: Wed, 18 Aug 2010 07:39:27 -0700
From: Greg KH <greg@kroah.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.2 regression, does not boot, sleeping function called
 from invalid context
Message-ID: <20100818143927.GA1202@kroah.com>
References: <20100817145305.GA7342@linux-m68k.org>
 <20100818133459.GA6663@kroah.com>
 <20100818140335.GB18303@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818140335.GB18303@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 04:03:35PM +0200, Richard Zidlicky wrote:
> On Wed, Aug 18, 2010 at 06:34:59AM -0700, Greg KH wrote:
> 
> > Does .35.1 work?
> 
> never tried but can give it a try tonight
> > .35.2 has some issues that are being worked on, the patches to solve the
> > bug is already in Linus's tree, give me a few days to get a new release
> > out with this solved.
> 
> thanks, can I find the new patches in git somewhere?

Yes, they are in Linus's tree, commits:
	d7824370e26325c881b665350ce64fb0a4fde24a
and
	11ac552477e32835cb6970bf0a70c210807f5673

thanks,

greg k-h
