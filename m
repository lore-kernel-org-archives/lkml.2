Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab0HSOj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:39:57 -0400
Received: from kroah.org ([198.145.64.141]:49756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0HSOjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:39:54 -0400
Date: Thu, 19 Aug 2010 07:37:12 -0700
From: Greg KH <greg@kroah.com>
To: Richard Zidlicky <rz@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.2 regression, does not boot, sleeping function called
	from invalid context
Message-ID: <20100819143712.GG13063@kroah.com>
References: <20100817145305.GA7342@linux-m68k.org> <20100818133459.GA6663@kroah.com> <20100818140335.GB18303@linux-m68k.org> <20100818143927.GA1202@kroah.com> <20100818200057.GA4132@linux-m68k.org> <20100818201751.GA31825@kroah.com> <20100818213428.GB4132@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818213428.GB4132@linux-m68k.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 11:34:29PM +0200, Richard Zidlicky wrote:
> On Wed, Aug 18, 2010 at 01:17:51PM -0700, Greg KH wrote:
> 
> > > Unfortunately no improvemenet with the hibernation problem that is there since
> > > 2.6.35?
> > 
> > That's different, right?
> 
> yes. I thought perhaps it might be this 
>   http://lkml.org/lkml/2010/8/6/7
> 
> suspend to ram works fine.
> 
> > And .34 works for you?  Can you run 'git bisect' on the tree to find the
> > offending patch?
> 
> 2.6.34 works. Bisect could take ages for me but I would try it as last resort.

bisect is faster than you might think :)

thanks,

greg k-h
