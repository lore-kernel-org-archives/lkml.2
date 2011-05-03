Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1ECXLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:11:20 -0400
Received: from kroah.org ([198.145.64.141]:35000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab1ECXLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:11:18 -0400
Date: Tue, 3 May 2011 16:06:30 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/23] intel_sst: Save audio state across D3 on Medfield
Message-ID: <20110503230630.GA26903@kroah.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
 <20110503163128.24853.15446.stgit@bob.linux.org.uk>
 <20110503174254.GA6545@kroah.com>
 <20110503222903.4200a6bd@lxorguk.ukuu.org.uk>
 <20110503213925.GA7453@opensource.wolfsonmicro.com>
 <20110503225316.5371c96b@lxorguk.ukuu.org.uk>
 <20110503220233.GB14080@kroah.com>
 <20110503222635.GA8035@opensource.wolfsonmicro.com>
 <20110503223237.GA25039@kroah.com>
 <20110503235917.0493fd0d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503235917.0493fd0d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:59:17PM +0100, Alan Cox wrote:
> > > I'm not really that interested in the Intel patches in staging, the bulk
> > > of them require a from scratch rewrite to go upstream as they're so far
> > > from following the Linux driver model for these things.
> > 
> > Ok, then I guess I can handle them.
> > 
> > Alan, how do you want to go about sending patches that we can apply
> > somehow?
> 
> Best bet is to apply Mark's patch into your git tree then apply mine on
> top I think. Git will see the same patch in both trees and resolve it all
> nicely for -next.

Have a pointer to which patch that was?

thanks,

greg k-h
